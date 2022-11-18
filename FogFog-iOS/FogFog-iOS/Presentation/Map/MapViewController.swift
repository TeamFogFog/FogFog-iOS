//
//  MapViewController.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import CoreLocation
import GoogleMaps
import SnapKit
import Then

final class MapViewController: BaseViewController {
    
    private lazy var navigationView = NavigationView()
    private let camera = GMSCameraPosition(latitude: 37.54330366639085, longitude: 127.04455548501139, zoom: 12)
    private var mapView = GMSMapView()
    private var myMarker = GMSMarker()
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignDelegation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        setLocation()
    }
    
    override func setLayout() {
        
        view.addSubview(navigationView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(102)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func assignDelegation() {
        
        locationManager.delegate = self
    }
    
    private func setLocation() {
        
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        move(at: locationManager.location?.coordinate)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func checkCurrentLocationAuthorization(authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            print("notDetermined")
        case .restricted, .denied:
            print("restricted")
        case .authorizedAlways, .authorizedWhenInUse:
            print("authorizedAlways")
        @unknown default:
            print("unknown")
        }
        
        if #available(iOS 14.0, *) {
            let accuracyState = locationManager.accuracyAuthorization
            switch accuracyState {
            case .fullAccuracy:
                print("full")
            case .reducedAccuracy:
                print("reduced")
            @unknown default:
                print("Unknown")
            }
        }
    }
    
    func checkUserLocationServicesAuthorization() {
        // iOS 14부터는 정확도 설정이 들어감
        // 시스템 설정을 다르게 해줌
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorization(authorizationStatus: authorizationStatus)
        } else {
            print("위치 권한 켜주세요")
        }
    }
    
    // iOS14 이상: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationServicesAuthorization()
    }
    
    // iOS14 미만: 앱이 위치 관리자를 생성하고, 승인 상태가 변경이 될 때 대리자에게 승인 상태를 알려줌
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserLocationServicesAuthorization()
    }
    
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let to = CLLocation(latitude: 37.54330366639082, longitude: 127.04455548501139)
        return from.distance(from: to)
    }
    
    func move(at coordinate: CLLocationCoordinate2D?) {
        if let coordinate = coordinate {
            let latitude = coordinate.latitude
            let longitude = coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 14.0)
            mapView.camera = camera
        }
    }
}
