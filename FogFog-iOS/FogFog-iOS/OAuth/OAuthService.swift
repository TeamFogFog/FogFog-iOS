//
//  OAuthService.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/24.
//

import RxSwift

final class OAuthService {
    
    private let oAuthService: OAuthServiceType
    
    init(oAuthService: OAuthServiceType) {
        self.oAuthService = oAuthService
    }
    
    func authorize() -> Single<OAuthAuthentication> {
        return oAuthService.authorize()
    }
}
