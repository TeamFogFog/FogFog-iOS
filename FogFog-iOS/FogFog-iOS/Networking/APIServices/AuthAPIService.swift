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
                // 성공 시 토큰 저장 --> keychain
                print("✨ OAuth 인증 성공) \(oauthAuthentication)")
            }
            .map { $0.toSignInRequestDTO() }
            .flatMap(signIn)
            .do { dto in
                print("🎉 로그인/회원가입 성공) \(dto?.id ?? -1) 유저님 환영합니다.")
                print("🎉 액세스 토큰 \(dto?.accessToken ?? "")")
                print("🎉 리프레시 토큰 \(dto?.refreshToken ?? "")")
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
