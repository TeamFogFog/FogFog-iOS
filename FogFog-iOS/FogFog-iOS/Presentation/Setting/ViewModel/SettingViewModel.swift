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
        let tapBackButton: Signal<Void>
    }
    
    struct Output {
        let didBackButtonTapped: Signal<Void>
    }
    
    func transform(input: Input) -> Output {
        let didBackButtonTapped = PublishRelay<Void>()
        let output = Output(didBackButtonTapped: didBackButtonTapped.asSignal())
        
        input.tapBackButton
            .emit(onNext: { _ in
                self.coordinator?.finish()
                didBackButtonTapped.accept(Void())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
