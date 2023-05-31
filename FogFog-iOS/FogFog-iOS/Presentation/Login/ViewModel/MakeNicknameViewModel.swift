//
//  MakeNicknameViewModel.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/25.
//

import UIKit

import RxSwift
import RxCocoa

final class MakeNicknameViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let didNicknameTextFieldChange: Observable<String>
        let tapConfirmButton: Signal<Void>
        let tapBackButton: Signal<Void>
    }
    
    struct Output {
        let didBackButtonTapped: Signal<Void>
        let didConfirmButtonTapped: Signal<Void>
        let isValid = PublishRelay<Bool>()
        let nickname = BehaviorRelay<String>(value: "")
    }
    
    func transform(input: Input) -> Output {
        let didBackButtonTapped = PublishRelay<Void>()
        let didConfirmButtonTapped = PublishRelay<Void>()
        let output = Output(didBackButtonTapped: didBackButtonTapped.asSignal(), didConfirmButtonTapped: didConfirmButtonTapped.asSignal())
        
        input.didNicknameTextFieldChange
            .subscribe(onNext: { text in
                output.nickname.accept(self.checkMaxLength(text: text))
            })
            .disposed(by: disposeBag)
        
        input.tapConfirmButton
            .withUnretained(self)
            .emit { owner, _ in
                owner.editUserNicknameAPI(userId: 13, nickname: output.nickname.value)
                didBackButtonTapped.accept(Void())
            }
            .disposed(by: disposeBag)
        
        input.tapBackButton
            .withUnretained(self)
            .emit { owner, _ in
                owner.coordinator?.navigationController.popViewController(animated: true)
                didBackButtonTapped.accept(Void())
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

extension MakeNicknameViewModel {
    
    /// 최대 8글자로 제한하는 메서드
    private func checkMaxLength(text: String, maxLength: Int = 8) -> String {
        if text.count > maxLength {
            let index = text.index(text.startIndex, offsetBy: 8)
            return String(text[..<index])
        } else {
            return text
        }
    }
}

// MARK: - Network
extension MakeNicknameViewModel {
    func editUserNicknameAPI(userId: Int, nickname: String) {
        UserAPIService.shared.editUserNickname(userId: userId, nickname: nickname)
            .subscribe(onSuccess: { result in
                UserDefaults.standard.set(result?.nickname, forKey: UserDefaults.Keys.nickname)
            }, onFailure: { error in
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .unauthorized:
                        print("unauthorized")
                    default:
                        print("network error")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
