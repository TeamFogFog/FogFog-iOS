//
//  ModernNetworkError.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

import Foundation

/// 네트워크 작업 중 발생할 수 있는 에러를 정의하는 열거형
/// - Note: HTTP 상태 코드 및 클라이언트 에러 처리
public enum ModernNetworkError: Error {
    /// - Parameters:
    ///   - statusCode: HTTP 상태 코드
    ///   - message: 서버에서 전달된 에러 메시지
    case http(statusCode: Int, message: String?)
    
    /// 잘못된 URL 형식
    case invalidURL
    /// JSON 디코딩 실패
    case decodingError(Error)
    /// 요청 시간 초과
    case timeout
    /// 인터넷 연결 없음
    case noInternetConnection
    
    struct ErrorResponse: Decodable {
        let message: String
    }
}

public extension ModernNetworkError {
    /// 400 Bad Request 에러 생성
    func invalidRequest(message: String? = nil) -> Self {
        .http(statusCode: 400, message: message)
    }
    
    /// 401 Unauthorized 에러 생성
    func unauthorized(message: String? = nil) -> Self {
        .http(statusCode: 401, message: message)
    }
    
    /// 403 Forbidden 에러 생성
    func forbidden(message: String? = nil) -> Self {
        .http(statusCode: 403, message: message)
    }
    
    /// 404 Not Found 에러 생성
    func notFound(message: String? = nil) -> Self {
        .http(statusCode: 404, message: message)
    }
    
    /// 409 Conflict 에러 생성
    func duplicated(message: String? = nil) -> Self {
        .http(statusCode: 409, message: message)
    }
    
    /// 500 Internal Server Error 생성
    func serverError(message: String? = nil) -> Self {
        .http(statusCode: 500, message: message)
    }
    
    /// HTTP 상태 코드와 응답 데이터로부터 에러 생성
    /// - Parameters:
    ///   - statusCode: HTTP 상태 코드
    ///   - data: 서버 응답 데이터
    func from(statusCode: Int, data: Data) -> Self {
        let message = try? JSONDecoder()
            .decode(ErrorResponse.self, from: data)
            .message
        return .http(statusCode: statusCode, message: message)
    }
    
    /// 에러 요약
    var errorDescription: String {
        switch self {
        case .http(let statusCode, let message):
            switch statusCode {
            case 400: return message ?? "잘못된 요청입니다."
            case 401: return message ?? "소셜 로그인 토큰이 유효하지 않습니다."
            case 403: return message ?? "해당 요청에 대한 권한이 없습니다."
            case 404: return message ?? "유효한 유저 정보가 없습니다."
            case 409: return message ?? "중복된 닉네임입니다."
            case 500: return message ?? "서버 내부 오류가 발생했습니다."
            default: return message ?? "알 수 없는 오류가 발생했습니다. (Status: \(statusCode))"
            }
        case .invalidURL: return "유효하지 않은 URL입니다."
        case .decodingError(let error): return "데이터 디코딩 실패: \(error.localizedDescription)"
        case .timeout: return "요청 시간이 초과되었습니다."
        case .noInternetConnection: return "인터넷 연결을 확인해주세요."
        }
    }
}
