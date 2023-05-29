//
//  OAuthProviderType.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/29.
//

import Foundation

/**
 - description: OAuth 서비스를 제공하는 제공자 종류
    우리 서비스의 경우 Apple, Kakao 서비스 사용
 */

enum OAuthProviderType: String, Hashable, CaseIterable {
    case kakao
    case apple
    
    var servive: OAuthServiceType {
        switch self {
        case .kakao:
            return KakaoOAuthService()
        default:
            return KakaoOAuthService()
        }
    }
}
