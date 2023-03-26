//
//  MapViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

import CoreLocation
import RxSwift
import RxCocoa

@frozen
enum LocationAuthorizationStatus {
    case allowed, disallowed, notDetermined
}

final class MapViewModel: ViewModelType {
    
    var authorizationStatus = PublishSubject<LocationAuthorizationStatus?>()
    var userLocation = PublishSubject<CLLocation>()
    var disposeBag = DisposeBag()
    
    private weak var coordinator: MapCoordinator?
    private let locationService: LocationService
    
    init(coordinator: MapCoordinator?, locationService: LocationService) {
        self.coordinator = coordinator
        self.locationService = locationService
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let tapMenuButton: Observable<Void>
        let tapBlurEffectView: Observable<Void>
    }
    
    struct Output {
        let isVisible: Driver<Bool>
        let currentUserLocation: Driver<CLLocationCoordinate2D>
    }
    
    func transform(input: Input) -> Output {
        
        let sideBarState = PublishRelay<Bool>()
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        
        input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.checkAuthorization()
                owner.observeUserLocation()
            })
            .disposed(by: disposeBag)
        
        input.tapMenuButton
            .subscribe { _ in
                sideBarState.accept(true)
            }
            .disposed(by: disposeBag)
        
        input.tapBlurEffectView
            .subscribe { _ in
                sideBarState.accept(false)
            }
            .disposed(by: disposeBag)
        
        self.userLocation
            .map({ $0.coordinate })
            .bind(to: currentUserLocation)
            .disposed(by: disposeBag)
        
        return Output(isVisible: sideBarState.asDriver(onErrorJustReturn: false),
                      currentUserLocation: currentUserLocation.asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: 20, longitude: 20)))
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
