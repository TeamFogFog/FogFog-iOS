//
//  MapViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

import RxSwift
import RxCocoa

final class MapViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private weak var coordinator: MapCoordinator?
    
    init(coordinator: MapCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let tapMenuButton: Signal<Void>
        let tapBlurEffectView: Signal<Void>
        let tapSettingButton: Signal<Void>
    }
    
    struct Output {
        let isVisible: Driver<Bool>
        let didSettingButtonTapped: Signal<Void>
    }
        
    func transform(input: Input) -> Output {
        let sideBarState = PublishRelay<Bool>()
        let didSettingButtonTapped = PublishRelay<Void>()
        let output = Output(isVisible: sideBarState.asDriver(onErrorJustReturn: false), didSettingButtonTapped: didSettingButtonTapped.asSignal())
        
        input.tapMenuButton
            .emit(onNext: { _ in
                sideBarState.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.tapBlurEffectView
            .emit(onNext: { _ in
                sideBarState.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.tapSettingButton
            .emit(onNext: { _ in
                self.coordinator?.connectSettingCoordinator()
                didSettingButtonTapped.accept(Void())
            })
            .disposed(by: disposeBag)
        
        return output
    }
}
