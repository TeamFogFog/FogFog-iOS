//
//  OAuthServiceType.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/29.
//

/**
 - description: OAuthService가 채택할 프로토콜
 */

import RxSwift

protocol OAuthServiceType {
    func authorize() -> Single<OAuthAuthentication>
}
