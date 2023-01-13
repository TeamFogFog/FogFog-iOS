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
        
    }
    
    struct Output {
    
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        return output
    }
}
