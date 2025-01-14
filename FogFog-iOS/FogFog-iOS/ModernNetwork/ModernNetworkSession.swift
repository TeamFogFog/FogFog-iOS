//
//  ModernNetworkSession.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

import UIKit

/// 네트워크 세션 동작을 정의하는 프로토콜
/// - Note: URLSession의 주요 네트워킹 기능을 추상화  정의
/// 
protocol NetworkSession {
   /// 데이터 요청 수행 및 응답 반환
   func data(for request: URLRequest) async throws -> (Data, URLResponse)
   
   /// 스트림 형태의 바이트 데이터 요청 수행
   func bytes(for request: URLRequest) async throws -> (URLSession.AsyncBytes, URLResponse)
}

extension URLSession: NetworkSession {
   func data(for request: URLRequest) async throws -> (Data, URLResponse) {
       try await data(for: request, delegate: nil)
   }
    
   @available(iOS 15.0, *)
   func bytes(for request: URLRequest) async throws -> (URLSession.AsyncBytes, URLResponse) {
       try await bytes(for: request, delegate: nil)
   }
}
