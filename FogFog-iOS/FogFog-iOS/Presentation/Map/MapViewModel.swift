//
//  MapViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift
import Moya

final class MapViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private weak var coordinator: MapCoordinator?
    
    init(coordinator: MapCoordinator?) {
        self.coordinator = coordinator
    }
    
    struct Input {
        let viewDidLoad: Signal<Void>
        let tapMenuButton: Signal<Void>
        let tapBlurEffectView: Signal<Void>
        let tapSettingButton: Signal<Void>
    }
    
    struct Output {
        let userNickname: BehaviorSubject<String>
        let isVisible: Driver<Bool>
        let didSettingButtonTapped: Signal<Void>
    }
    
    let userNickname = BehaviorSubject<String>(value: "")
        
    func transform(input: Input) -> Output {
        let sideBarState = PublishRelay<Bool>()
        let didSettingButtonTapped = PublishRelay<Void>()
        let output = Output(userNickname: userNickname, isVisible: sideBarState.asDriver(onErrorJustReturn: false), didSettingButtonTapped: didSettingButtonTapped.asSignal())
        
        input.viewDidLoad
            .emit(onNext: { _ in
                // TODO: 유저아이디 추후 변경 예정 (로그인 후 UserDefaults에 저장된 값으로)
                self.getUserNicknameAPI(userId: 13)
            })
            .disposed(by: disposeBag)
        
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
            .withUnretained(self)
            .emit { owner, _ in
                owner.coordinator?.connectSettingCoordinator()
            }
            .disposed(by: disposeBag)
        
        return output
    }
}

// MARK: - Network
extension MapViewModel {
    func getUserNicknameAPI(userId: Int) {
        UserAPIService.shared.getUserNickname(userId: userId)
            .subscribe(onSuccess: { result in
                self.userNickname.onNext(result?.nickname ?? "")
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
