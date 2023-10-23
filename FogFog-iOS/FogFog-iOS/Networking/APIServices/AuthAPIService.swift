//
//  AuthAPIService.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/30.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

protocol AuthAPIServiceType {
    func login() -> Single<Void>
}

final class AuthAPIService: Networking, AuthAPIServiceType {
    
    // MARK: - Type Alias
    typealias API = AuthAPI
    
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    private let provider = NetworkProvider<API>()
    private var oauthService: OAuthServiceType
    
    // MARK: - Initialization
    init(oauthService: OAuthServiceType) {
        self.oauthService = oauthService
    }
    
    /// 로그인 메서드
    /// OAuth 인증 --> 포그포그 서버 로그인/회원가입 인증 수행
    /// OAuthService의 OAuthServiceType만 바꿔 끼워주더라도 인증 로직은 변경없이 수행됩니다.
    func login() -> Single<Void> {
        return oauthService
            .authorize()
            .do { oauthAuthentication in
                #if DEBUG
                print("✨ OAuth 인증 성공) \(oauthAuthentication)")
                #endif
                
                let authType = oauthAuthentication.oauthType.rawValue
                Keychain.create(key: Keychain.Keys.socialType, data: authType)
            }
            .map { $0.toSignInRequestDTO() }
            .flatMap(signIn)
            .do { dto in
                if let dto {
                    UserDefaults.isFirstLaunch = false
                    UserDefaults.userId = dto.id ?? -1
                    Keychain.create(key: Keychain.Keys.accessToken, data: dto.accessToken)
                    Keychain.create(key: Keychain.Keys.refreshToken, data: dto.refreshToken)
                } else {
                    #if DEBUG
                    print("포그포그 서버 인증 실패")
                    #endif
                    // TODO: 네트워크 오류 팝업 띄워주기
                }
            }
            .map { _ in () }
    }
    
    // 실제 로그인/회원가입 Request
    private func signIn(_ request: SignInRequestDTO) -> Single<SignInResponseDTO?> {
        return provider
            .request(.signIn(request: request))
            .map(SignInResponseDTO.self)
    }
}
