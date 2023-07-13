//
//  AppleOAuthService.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/07/04.
//

import UIKit

import AuthenticationServices
import RxSwift

final class AppleOAuthService: OAuthServiceType {
    
    private let disposeBag = DisposeBag()
    private let appleLoginManager = AppleLoginManager()
    
    func authorize() -> Single<OAuthAuthentication> {
        return login().map { OAuthAuthentication(oauthType: .apple, idToken: $0.id, code: $0.code) }
    }
    
    private func login() -> Single<AppleUserModel> {
        return Single.create { observer in
            self.appleLoginManager
                .handleAuthorizationAppleIDButtonPress()
                .subscribe(onNext: { result in
                    guard
                        let auth = result.credential as? ASAuthorizationAppleIDCredential,
                        let idToken = auth.identityToken,
                        let code = auth.authorizationCode
                    else { return }
                    
                    let appleUser = AppleUserModel(id: String(decoding: idToken, as: UTF8.self),
                                              code: String(decoding: code, as: UTF8.self),
                                              email: auth.email ?? "")
                    observer(.success(appleUser))
                }, onError: { error in
                    observer(.failure(error))
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
}
