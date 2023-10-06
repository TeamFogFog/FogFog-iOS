//
//  MapViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import CoreLocation

import RxCocoa
import RxSwift
import Moya

@frozen
enum LocationAuthorizationStatus {
    case allowed, disallowed, notDetermined
}

final class MapViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    var authorizationStatus = PublishSubject<LocationAuthorizationStatus?>()
    var userLocation = PublishSubject<CLLocation>()
    
    private weak var coordinator: MapCoordinator?
    private let locationService: LocationService
    
    init(coordinator: MapCoordinator?, locationService: LocationService) {
        self.coordinator = coordinator
        self.locationService = locationService
    }
    
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let viewWillAppear: ControlEvent<Bool>
        let tapMenuButton: ControlEvent<Void>
        let tapBlurEffectView: Signal<Void>
        let tapSettingButton: ControlEvent<Void>
    }
    
    struct Output {
        let userNickname: BehaviorSubject<String>
        let isVisible: Driver<Bool>
        let didSettingButtonTapped: Signal<Void>
        let currentUserLocation: Driver<CLLocationCoordinate2D>
    }
    
    let userNickname = BehaviorSubject<String>(value: UserDefaults.nickname ?? "")
    
    func transform(input: Input) -> Output {
        let sideBarState = PublishRelay<Bool>()
        let didSettingButtonTapped = PublishRelay<Void>()
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        
        let output = Output(userNickname: userNickname,
                            isVisible: sideBarState.asDriver(onErrorJustReturn: false),
                            didSettingButtonTapped: didSettingButtonTapped.asSignal(),
                            currentUserLocation: currentUserLocation.asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: 20, longitude: 20)))
        
        input.viewDidLoad
            .subscribe(with: self, onNext: { owner, _ in
                owner.checkAuthorization()
                owner.observeUserLocation()
                if UserDefaults.nickname == nil {
                    owner.getUserNicknameAPI(userId: UserDefaults.userId ?? -1)
                }
            })
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .subscribe(with: self, onNext: { owner, _ in
                owner.userNickname.onNext(UserDefaults.nickname ?? "")
            })
            .disposed(by: disposeBag)
        
        input.tapMenuButton
            .subscribe(onNext: { _ in
                sideBarState.accept(true)
            })
            .disposed(by: disposeBag)
        
        input.tapBlurEffectView
            .emit(onNext: { _ in
                sideBarState.accept(false)
            })
            .disposed(by: disposeBag)
        
        input.tapSettingButton
            .subscribe(with: self, onNext: { owner, _ in
                owner.coordinator?.showSettingFlow()
            })
            .disposed(by: disposeBag)
        
        self.userLocation
            .map({ $0.coordinate })
            .bind(to: currentUserLocation)
            .disposed(by: disposeBag)
        
        return output
    }
}

private extension MapViewModel {
    
    func checkAuthorization() {
        self.locationService.observeUpdatedAuthorization()
            .withUnretained(self)
            .subscribe(onNext: { owner, status in
                switch status {
                case .authorizedAlways, .authorizedWhenInUse:
                    owner.authorizationStatus.onNext(.allowed)
                    owner.locationService.start()
                case .notDetermined:
                    owner.authorizationStatus.onNext(.notDetermined)
                    owner.locationService.requestAuthorization()
                case .denied, .restricted:
                    owner.authorizationStatus.onNext(.disallowed)
                @unknown default:
                    owner.authorizationStatus.onNext(nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func observeUserLocation() {
        return self.locationService.observeUpdatedLocation()
            .compactMap({ $0.last })
            .withUnretained(self)
            .subscribe(onNext: { owner, location in
                owner.userLocation.onNext(location)
            })
            .disposed(by: self.disposeBag)
    }
}

// MARK: - Network
extension MapViewModel {
    func getUserNicknameAPI(userId: Int) {
        UserAPIService.shared.getUserNickname(userId: userId)
            .subscribe(onSuccess: { result in
                self.userNickname.onNext(result?.nickname ?? "")
                UserDefaults.nickname = result?.nickname
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
