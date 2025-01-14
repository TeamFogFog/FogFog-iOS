//
//  ModernURLRequestBuildable.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

import UIKit

/// URL 요청 생성을 위한 프로토콜
/// - Note: endpoint 기반으로 URLRequest를 생성하는 프로토콜
protocol ModernURLRequestBuildable {
   /// endpoint로부터 URLRequest를 생성
   func buildRequest(from endpoint: ModernEndpoint) throws -> URLRequest
}

/// URLRequest 생성을 담당하는 구조체
/// - Note: ModernURLRequestBuildable 프로토콜 기본 구현체
struct ModernURLRequestBuilder: ModernURLRequestBuildable {
   func buildRequest(from endpoint: ModernEndpoint) throws -> URLRequest {
       // baseURL + path
       let url = URL(string: NetworkEnv.baseURL)!.appendingPathComponent(endpoint.path)
       var request = URLRequest(url: url)
       request.httpMethod = endpoint.method.rawValue
       
       // header
       endpoint.headers?.forEach { request.addValue($1, forHTTPHeaderField: $0) }
       
       // HTTP 메서드가 GET이 아닌 경우, 파라미터를 JSON 형태로 변환하여 body에 추가
       switch endpoint.task {
        case .query(let query):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
           var components = URLComponents(string: url.appendingPathComponent(endpoint.path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            
        case .queryBody(let query, let body):
            let queryParams = query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            var components = URLComponents(string: url.appendingPathComponent(endpoint.path).absoluteString)
            components?.queryItems = queryParams
            request.url = components?.url
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .requestBody(let body):
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            
        case .requestPlain:
            break
        }
        
        return request
   }
}
