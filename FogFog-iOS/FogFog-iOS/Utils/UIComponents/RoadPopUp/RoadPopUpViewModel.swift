//
//  RoadPopUpViewModel.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import Foundation

import RxCocoa
import RxSwift

final class RoadPopUpViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()

    struct Input {
        let kakaoButtonTrigger: ControlEvent<Void>
        let googleButtonTrigger: ControlEvent<Void>
        let naverButtonTrigger: ControlEvent<Void>
        let confirmButtonTrigger: ControlEvent<Void>
        let closeButtonTrigger: ControlEvent<Void>
    }
    
    struct Output {
        let didSelectMap = PublishRelay<ExMapType>()
        let didConfirm = PublishRelay<Void>()
        let didCancel = PublishRelay<Void>()
    }
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.kakaoButtonTrigger
            .asSignal()
            .map { .kakao }
            .emit(to: output.didSelectMap)
            .disposed(by: disposeBag)
        
        input.googleButtonTrigger
            .asSignal()
            .map { .google }
            .emit(to: output.didSelectMap)
            .disposed(by: disposeBag)
        
        input.naverButtonTrigger
            .asSignal()
            .map { .naver }
            .emit(to: output.didSelectMap)
            .disposed(by: disposeBag)
        
        // didSelectMap
        // - 1) 맵 선택 정보 기기 자체에 저장
        // - 2) 서버에 지도 선택 통신 요청
        input.confirmButtonTrigger
            .asSignal()
            .emit(to: output.didConfirm)
            .disposed(by: disposeBag)

        input.closeButtonTrigger
            .asSignal()
            .emit(to: output.didCancel)
            .disposed(by: disposeBag)

        return output
    }
}
