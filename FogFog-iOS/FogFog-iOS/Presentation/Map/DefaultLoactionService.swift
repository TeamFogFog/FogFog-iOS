//
//  DefaultLocationService.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2023/07/24.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

final class DefaultLocationService: NSObject, LocationService {
   
    var locationManager: CLLocationManager?
    var disposeBag: DisposeBag = DisposeBag()
    var authorizationStatus = BehaviorRelay<CLAuthorizationStatus>(value: .notDetermined)
    var location = BehaviorRelay<[CLLocation]>(value: [CLLocation(latitude: 0, longitude: 0)])
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.distanceFilter = CLLocationDistance(3)
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func start() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    func requestAuthorization() {
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus> {
        return self.authorizationStatus.asObservable()
    }
    
    func observeUpdatedLocation() -> Observable<[CLLocation]> {
        return PublishRelay<[CLLocation]>.create({ emitter in
            self.rx.methodInvoked(#selector(CLLocationManagerDelegate.locationManager(_:didUpdateLocations:)))
                .compactMap({ $0.last as? [CLLocation] })
                .subscribe(onNext: { location in
                    emitter.onNext(location)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        })
    }
}

extension DefaultLocationService: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                print(self.location.value)
            }
            self.location.accept(locations)

        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorizationStatus.accept(status)
    }
}

