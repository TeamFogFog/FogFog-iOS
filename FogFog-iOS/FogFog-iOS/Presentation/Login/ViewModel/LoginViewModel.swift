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

    struct Input {
        let kakaoButtonDidTap: Observable<Void>
        let appleButtonDidTap: Observable<Void>
    }
    
    struct Output {
        let loginResult: Driver<String>
    }
    
    // MARK: - Property
    
    var disposeBag = DisposeBag()
    
    private let coordinator: LoginCoordinator
    private let factory: (OAuthProviderType) -> AuthAPIServiceType
    
    // MARK: - Initialization
    
    init(
        coordinator: LoginCoordinator,
        factory: @escaping (OAuthProviderType) -> AuthAPIServiceType
    ) {
        self.coordinator = coordinator
        self.factory = factory
    }
    
    func transform(input: Input) -> Output {
        let result = PublishSubject<String>()
        
        input.kakaoButtonDidTap
            .flatMap(loginWithKakao)
            .subscribe { _ in
                result.onNext("success!")
                self.coordinator.showMakeNicknameViewController("닉네임 설정")
            } onError: { error in
                result.onNext("error: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        input.appleButtonDidTap
            .flatMap(loginWithApple)
            .subscribe { _ in
                result.onNext("success!")
                self.coordinator.showMakeNicknameViewController("닉네임 설정")
            } onError: { error in
                result.onNext("error: \(error.localizedDescription)")
            }
            .disposed(by: disposeBag)
        
        return Output(loginResult: result.asDriver(onErrorDriveWith: .empty()))
    }
    
    private func loginWithKakao() -> Observable<Void> {
        return factory(.kakao).login().asObservable()
    }
    
    private func loginWithApple() -> Observable<Void> {
        return factory(.apple).login().asObservable()
    }
}
