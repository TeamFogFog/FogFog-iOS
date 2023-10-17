//
//  SettingViewModel.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import Foundation

import RxCocoa
import RxSwift

final class SettingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    private weak var coordinator: SettingCoordinator?
    
    init(coordinator: SettingCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let viewWillAppear: ControlEvent<Bool>
        let tapBackButton: Signal<Void>
        let tapEditNicknameButton: Signal<Void>
    }
    
    struct Output {
        let nickname: BehaviorSubject<String>
        let didBackButtonTapped: Signal<Void>
        let didEditNicknameButtonTapped: Signal<Void>
    }
    
    let nickname = BehaviorSubject<String>(value: UserInfo.nickname)
    
    func transform(input: Input) -> Output {
        let didBackButtonTapped = PublishRelay<Void>()
        let didEditNicknameButtonTapped = PublishRelay<Void>()
        let output = Output(nickname: nickname,
                            didBackButtonTapped: didBackButtonTapped.asSignal(),
                            didEditNicknameButtonTapped: didEditNicknameButtonTapped.asSignal())
        
        input.viewWillAppear
            .subscribe(with: self, onNext: { owner, _ in
                owner.nickname.onNext(UserInfo.nickname)
            })
            .disposed(by: disposeBag)
        
        input.tapBackButton
            .withUnretained(self)
            .emit { owner, _ in
                owner.coordinator?.finish()
            }
            .disposed(by: disposeBag)
        
        input.tapEditNicknameButton
            .withUnretained(self)
            .emit { owner, _ in
                owner.coordinator?.showEditNicknameViewController()
            }
            .disposed(by: disposeBag)
        
        return output
    }
}
