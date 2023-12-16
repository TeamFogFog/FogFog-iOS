//
//  LocationService.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2023/07/24.
//

import CoreLocation
import Foundation

import RxSwift
import RxRelay

protocol LocationService {
    var authorizationStatus: BehaviorRelay<CLAuthorizationStatus> { get set }
    var location: BehaviorRelay<[CLLocation]> { get set }
    func start()
    func stop()
    func requestAuthorization()
    func observeUpdatedAuthorization() -> Observable<CLAuthorizationStatus>
    func observeUpdatedLocation() -> Observable<[CLLocation]>
}
