//
//  LoginViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift

final class LoginViewModel: ViewModelType {
    
    struct Dependency {
        let coordinator: LoginCoordinator
        // TODO: - AuthService로 교체해야 함
        let oAuthService: OAuthService
    }
    
    struct Input {
        let kakaoButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let loginResult: Driver<String>
    }
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    private let coordinator: LoginCoordinator
    private let oAuthService: OAuthService
    
    // MARK: - Initialization
    
    init(dependency: Dependency) {
        self.coordinator = dependency.coordinator
        self.oAuthService = dependency.oAuthService
    }
    
    func transform(input: Input) -> Output {
        let result = PublishSubject<String>()
        
        input.kakaoButtonDidTap
            .flatMap(loginWithKakao)
            // .(생략)자체 서버 회원가입/로그인
            .subscribe { auth in
                result.onNext("success: \(auth.token)")
            } onError: { error in
                result.onNext("error: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        return Output(loginResult: result.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func loginWithKakao() -> Observable<OAuthAuthentication> {
        return oAuthService.authorize().asObservable()
    }
}
