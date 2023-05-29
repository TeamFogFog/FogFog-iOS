//
//  KakaoOAuthService.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/21.
//

import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxSwift

final class KakaoOAuthService: OAuthServiceType {

    private let disposeBag = DisposeBag()
    
    func authorize() -> Single<OAuthAuthentication> {
        return self.login().map { .init(oauthType: .kakao, token: $0.accessToken) }
    }

    private func login() -> Single<OAuthToken> {
        let isKakaoTalkLoginAvailable = UserApi.isKakaoTalkLoginAvailable()
        
        return Single.create { observer in
            if isKakaoTalkLoginAvailable {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { oAuthToken in
                        observer(.success(oAuthToken))
                    }, onError: { error in
                        observer(.failure(error))
                    })
                    .disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { oAuthToken in
                        observer(.success(oAuthToken))
                    }, onError: { error in
                        observer(.failure(error))
                    })
                    .disposed(by: self.disposeBag)
            }
            
            return Disposables.create()
        }
    }
}
