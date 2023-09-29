//
//  MakeNicknameViewModel.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/25.
//

import UIKit

import Moya
import RxSwift
import RxCocoa

final class MakeNicknameViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private weak var coordinator: Coordinator?
    
    init(coordinator: Coordinator?) {
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
    
    let output = Output(didBackButtonTapped: PublishRelay<Void>().asSignal(),
                        didConfirmButtonTapped: PublishRelay<Void>().asSignal())
    
    func transform(input: Input) -> Output {
        input.didNicknameTextFieldChange
            .subscribe(onNext: { text in
                self.output.isValid.accept(true)
                self.output.nickname.accept(self.checkMaxLength(text: text))
            })
            .disposed(by: disposeBag)
        
        input.tapConfirmButton
            .withUnretained(self)
            .emit { owner, _ in
                owner.editUserNicknameAPI(userId: UserDefaults.userId ?? -1, nickname: self.output.nickname.value)
            }
            .disposed(by: disposeBag)
        
        input.tapBackButton
            .withUnretained(self)
            .emit { owner, _ in
                owner.coordinator?.navigationController.popViewController(animated: true)
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
    
    // 유저 닉네임 수정 요청 메서드
    func editUserNicknameAPI(userId: Int, nickname: String) {
        UserAPIService.shared.editUserNickname(userId: userId, nickname: nickname)
            .subscribe(onSuccess: { result in
                // 닉네임 등록 or 수정 성공 시 UserDefaults 값 갱신, 화면 전환
                UserDefaults.nickname = result?.nickname
                self.output.isValid.accept(true)
                self.coordinator?.finish()
            }, onFailure: { error in
                if let moyaError = error as? MoyaError {
                    if let statusCode = moyaError.response?.statusCode {
                        let networkError = NetworkError(rawValue: statusCode)
                        switch networkError {
                        case .unauthorized:
                            print("unauthorized")
                        case .duplicated:
                            self.output.isValid.accept(false)
                        default:
                            print("network error")
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
