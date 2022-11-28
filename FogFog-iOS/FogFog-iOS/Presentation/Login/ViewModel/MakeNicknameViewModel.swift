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
    }
    
    struct Output {
        let isValid = PublishRelay<Bool>()
        let nickname = PublishRelay<String>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.didNicknameTextFieldChange
            .subscribe(onNext: { text in
                output.nickname.accept(self.checkMaxLength(text: text))
                output.isValid.accept(self.checkNicknameValidation(text))
            })
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
    
    /// 닉네임 유효성 검사 메서드
    private func checkNicknameValidation(_ text: String) -> Bool {
        
        // TODO: 닉네임 검사 로직 수정 예정
        return text != "닉네임"
    }
}
