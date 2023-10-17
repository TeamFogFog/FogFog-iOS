//
//  ExternalMapModalViewModel.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import Foundation

import RxCocoa
import RxSwift

final class ExternalMapModalViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let kakaoMapButtonDidTap: ControlEvent<Void>
        let googleMapButtonDidTap: ControlEvent<Void>
        let naverMapButtonDidTap: ControlEvent<Void>
        let confirmButtonDidTap: ControlEvent<Void>
        let closeButtonDidTap: ControlEvent<Void>
    }
    
    struct Output {
        let selectedMap: PublishRelay<ExternalMapType>
    }
    
    func transform(input: Input) -> Output {
        let selectedMap = PublishRelay<ExternalMapType>()
        
        input.kakaoMapButtonDidTap
            .asSignal()
            .map { ExternalMapType.kakao }
            .emit(to: selectedMap)
            .disposed(by: disposeBag)
        
        input.googleMapButtonDidTap
            .asSignal()
            .map { ExternalMapType.google }
            .emit(to: selectedMap)
            .disposed(by: disposeBag)
        
        input.naverMapButtonDidTap
            .asSignal()
            .map { ExternalMapType.naver }
            .emit(to: selectedMap)
            .disposed(by: disposeBag)
        
        input.confirmButtonDidTap
            .withLatestFrom(selectedMap)
            .withUnretained(self)
            .flatMap { owner, mapType in
                let userId = UserInfo.userId
                let mapId = mapType.rawValue
                return owner.setPreferredMap(userId: userId, mapId: mapId)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(selectedMap: selectedMap)
    }
    
    func setPreferredMap(userId: Int, mapId: Int) -> Observable<Void> {
        return UserAPIService.shared
            .setPreferredMap(userId: userId, mapId: mapId)
            .compactMap { _ in () }
            .asObservable()
    }
}
