//
//  NetworkError.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/15.
//

import Foundation

/// FogFog 네트워크 통신에서 공통적으로 발생하는 에러
enum NetworkError: Int {
    case invalidRequest = 400   // Bad Request (Client Error)
    case unauthorized   = 401   // 소셜 로그인 토큰이 없거나 유효하지 않은 경우
    case forbidden      = 403   // 요청 id와 accessToken 정보가 매칭되지 않는 경우
    case notFound       = 404   // 유효한 유저 정보가 없는 경우
    case duplicated     = 409   // 중복된 닉네임일 경우
    case serverError    = 500   // Internal Server Error
}
