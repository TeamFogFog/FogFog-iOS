//
//  OAuthAuthentication.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/29.
//

import Foundation

struct OAuthAuthentication {
    var oauthType: OAuthProviderType
    var kakaoAccessToken: String?
    var idToken: String?
    var code: String?
}

extension OAuthAuthentication {
    
    func toSignInRequestDTO() -> SignInRequestDTO {
        return .init(
            socialType: oauthType.rawValue,
            kakaoAccessToken: kakaoAccessToken,
            idToken: idToken,
            code: code
        )
    }
}
