//
//  ModernNetworkService.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

import UIKit

protocol Networking {
    /// 기본 네트워크 요청 수행
    func request<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type
    ) async throws -> T
    
    /// 취소 가능한 네트워크 요청 수행
    func cancellableRequest<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type
    ) async -> AsyncThrowingStream<T, Error>
    
    /// 진행률을 포함한 네트워크 요청 수행
    func requestWithProgress<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type
    ) async -> AsyncThrowingStream<(T?, Double), Error>
    
    /// 재시도 네트워크 요청 수행
    func requestWithRetry<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type,
        maxRetries: Int
    ) async throws -> T
    
    /// 타임아웃이 포함된 네트워크 요청 수행
    func requestWithTimeout<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type,
        timeout: TimeInterval
    ) async throws -> T
}

/// 네트워크 요청을 처리하는 actor 클래스
/// - Note: Thread-safe한 네트워크 작업을 위해 actor로 구현
/// - Author: seungchan
actor NetworkService: Networking {
    // MARK: - Properties
    /// 네트워크 세션을 관리
    private let session: NetworkSession
    /// HTTP 요청을 생성하는 빌더
    private let requestBuilder: ModernURLRequestBuildable
    /// 응답 데이터를 디코딩하는 인스턴스
    private let responseDecoder: ResponseDecoding
    /// 현재 활성화된 요청들을 저장하는 딕셔너리
    private var activeRequests: [String: Task<Any, Error>] = [:]
    
    // MARK: - Initialization
    /// - Parameters:
    ///   - session: 네트워크 세션 (기본값: URLSession.shared)
    ///   - requestBuilder: HTTP 요청 빌더 (기본값: URLRequestBuilder())
    ///   - responseDecoder: 응답 디코더 (기본값: JSONResponseDecoder())
    init(
        session: NetworkSession = URLSession.shared,
        requestBuilder: ModernURLRequestBuildable = ModernURLRequestBuilder(),
        responseDecoder: ResponseDecoding = JSONResponseDecoder()
    ) {
        self.session = session
        self.requestBuilder = requestBuilder
        self.responseDecoder = responseDecoder
    }
    
    // MARK: - Public Methods
       
    /// 기본 네트워크 요청 수행
    /// - Parameters:
    ///   - endpoint: 요청할 Endpoint
    ///   - type: 응답 데이터를 디코딩할 타입
    /// - Returns: 디코딩된 응답 데이터
    /// - Throws: NetworkError
    func request<T: Decodable>(
        _ endpoint: Endpoint,
        type: T.Type
    ) async throws -> T {
        let request = try requestBuilder.buildRequest(from: endpoint)
        let (data, response) = try await session.data(for: request)
        return try processResponse(data: data, response: response, type: type)
    }
    
    /// 취소 가능한 네트워크 요청 수행
    /// - Parameters:
    ///   - endpoint: 요청할 Endpoint
    ///   - type: 응답 데이터를 디코딩할 타입
    /// - Returns: AsyncThrowingStream으로 래핑된 응답 데이터
    func cancellableRequest<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type
    ) -> AsyncThrowingStream<T, Error> {
        AsyncThrowingStream { continuation in
            let requestId = UUID().uuidString
            
            let task = Task<Any, Error> {
                do {
                    let result = try await request(endpoint, type: type)
                    continuation.yield(result)
                    continuation.finish()
                    return result
                } catch {
                    continuation.finish(throwing: error)
                    throw error
                }
            }
            
            storeTask(task, for: requestId)
            
            continuation.onTermination = { [weak self] _ in
                Task { [weak self] in
                    await self?.removeTask(for: requestId)
                }
            }
        }
    }
    
    /// 진행률을 포함한 네트워크 요청 수행
    /// - Parameters:
    ///   - endpoint: 요청할 Endpoint
    ///   - type: 응답 데이터를 디코딩할 타입
    /// - Returns: 진행률과 함께 응답 데이터를 스트림으로 반환
    func requestWithProgress<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type
    ) -> AsyncThrowingStream<(T?, Double), Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let request = try requestBuilder.buildRequest(from: endpoint)
                    let (bytes, response) = try await session.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.expectedContentLength > 0 else {
                        throw NetworkError.invalidURL
                    }
                    
                    let expectedLength = httpResponse.expectedContentLength
                    var accumulated = Data()
                    var lastReportedProgress: Int = -1
                    
                    for try await byte in bytes {
                        accumulated.append(byte)
                        let progress = Double(accumulated.count) / Double(expectedLength)
                        let roundedProgress = Int(progress * 100)
                        
                        if roundedProgress != lastReportedProgress {
                            lastReportedProgress = roundedProgress
                            if accumulated.count == expectedLength {
                                let result: T = try processResponse(
                                    data: accumulated,
                                    response: response,
                                    type: type
                                )
                                continuation.yield((result, 1.0))
                            } else {
                                continuation.yield((nil, progress))
                            }
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    /// 재시도 네트워크 요청 수행
    /// - Parameters:
    ///   - endpoint: 요청할 Endpoint
    ///   - type: 응답 데이터를 디코딩할 타입
    ///   - maxRetries: 최대 재시도 횟수
    /// - Returns: 디코딩된 응답 데이터
    /// - Throws: NetworkError
    func requestWithRetry<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type,
        maxRetries: Int
    ) async throws -> T {
        var remainingAttempts = maxRetries
        var lastError: Error?
        
        repeat {
            do {
                return try await request(endpoint, type: type)
            } catch {
                lastError = error
                remainingAttempts -= 1
                
                if remainingAttempts > 0 {
                    try await Task.sleep(nanoseconds: calculateBackoff(attempt: maxRetries - remainingAttempts))
                }
            }
        } while remainingAttempts > 0
        
        throw lastError ?? NetworkError.invalidURL
    }
    
    /// 타임아웃이 포함된 네트워크 요청 수행
    /// - Parameters:
    ///   - endpoint: 요청할 Endpoint
    ///   - type: 응답 데이터를 디코딩할 타입
    ///   - timeout: 타임아웃 시간 (초)
    /// - Returns: 디코딩된 응답 데이터
    func requestWithTimeout<T: Decodable>(
        _ endpoint: ModernEndpoint,
        type: T.Type,
        timeout: TimeInterval
    ) async throws -> T {
        try await withThrowingTaskGroup(of: T.self) { group in
            group.addTask {
                try await self.request(endpoint, type: type)
            }
            
            group.addTask {
                try await Task.sleep(nanoseconds: UInt64(timeout * 1_000_000_000))
                throw NetworkError.invalidURL
            }
            
            for try await result in group {
                group.cancelAll()
                return result
            }
            
            throw NetworkError.invalidRequest
        }
    }
    
    // MARK: - Private Methods
    /// HTTP 응답을 처리 및 데이터 디코딩
    private func processResponse<T: Decodable>(
        data: Data,
        response: URLResponse,
        type: T.Type
    ) throws -> T {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.http(statusCode: 0, message: "Invalid HTTP response")
        }
        
        if (200...299).contains(httpResponse.statusCode) {
            do {
                return try responseDecoder.decode(type, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        }
        
        throw NetworkError.from(statusCode: httpResponse.statusCode, data: data)
    }
    
    /// 재시도 간격을 계산
    private func calculateBackoff(attempt: Int) -> UInt64 {
        let baseDelay: UInt64 = 1_000_000_000
        let maxDelay: UInt64 = 10_000_000_000
        let delay = baseDelay * UInt64(pow(2.0, Double(attempt)))
        return min(delay, maxDelay)
    }
    
    /// 활성 요청을 저장
    private func storeTask(_ task: Task<Any, Error>, for identifier: String) {
        activeRequests[identifier] = task
    }
    
    /// 활성 요청을 제거하고 취소
    private func removeTask(for identifier: String) {
        activeRequests[identifier]?.cancel()
        activeRequests.removeValue(forKey: identifier)
    }
}
