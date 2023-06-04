//
//  MapViewController.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import CoreLocation
import GoogleMaps
import RxCocoa
import RxSwift
import SnapKit
import Then

final class MapViewController: BaseViewController {
    
    // MARK: Properties
    private lazy var navigationView = NavigationView()
    private lazy var sideBarView = SideBarView()
    private var blurEffectView: UIVisualEffectView!
    private let camera = GMSCameraPosition(latitude: 37.54330366639085, longitude: 127.04455548501139, zoom: 12)
    private var mapView = GMSMapView()
    private var myMarker = GMSMarker()
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    private var viewModel: MapViewModel
    private let tapBlurEffectView = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: Init
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MapViewController Error!")
    }
    
    // MARK: Life Cycle
    override func loadView() {
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assignDelegation()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        setLocation()
    }
    
    // MARK: UI
    override func setStyle() {
        let blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.6
        blurEffectView.isHidden = true
    }
    
    override func setLayout() {
        view.addSubviews([navigationView, blurEffectView, sideBarView])
        
        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(102)
            $0.leading.trailing.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
        sideBarView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(-309)
            $0.width.equalTo(309)
        }
    }
}

// MARK: - Bind
extension MapViewController {
    
    private func bind() {
        let input = MapViewModel.Input(
            viewDidLoad: Signal<Void>.just(()),
            tapMenuButton: navigationView.menuButton.rx.tap.asSignal(),
            tapBlurEffectView: tapBlurEffectView.asSignal(),
            tapSettingButton: sideBarView.settingButtonDidTap())
        let output = viewModel.transform(input: input)
        
        output.isVisible
            .asDriver()
            .drive(with: self) { owner, state in
                owner.setSideBarViewLayout(isVisible: state)
            }
            .disposed(by: disposeBag)
        
        output.didSettingButtonTapped
            .emit()
            .disposed(by: disposeBag)
        
        output.userNickname
            .subscribe(onNext: { result in
                self.sideBarView.nicknameLabel.text = result
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Methods
extension MapViewController {
    
    private func assignDelegation() {
        locationManager.delegate = self
    }
    
    private func setLocation() {
        mapView.isMyLocationEnabled = true
        locationManager.startUpdatingLocation()
        move(at: locationManager.location?.coordinate)
    }
    
    private func setSideBarViewLayout(isVisible: Bool = false) {
        blurEffectView.isHidden = !isVisible
        
        sideBarView.snp.updateConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(isVisible ? 0 : -309)
            $0.width.equalTo(309)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first,
           touch.view == self.blurEffectView {
            self.tapBlurEffectView.accept(())
        }
    }
}

// MARK: - CLLocationManagerDelegate
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
