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
    }
    
    struct Output {
        let isVisible: Driver<Bool>
    }
        
    func transform(input: Input) -> Output {
        
        let sideBarState = PublishRelay<Bool>()
        
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
        
        return Output(isVisible: sideBarState.asDriver(onErrorJustReturn: false))
    }
}
