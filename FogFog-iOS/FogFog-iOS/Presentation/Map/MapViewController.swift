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
    private lazy var input = MapViewModel.Input(viewDidLoad: Observable.just(()),
                                                tapMenuButton: navigationView.menuButton.rx.tap.asObservable(),
                                                tapBlurEffectView: tapBlurEffectView.asObservable())
    private lazy var output = viewModel.transform(input: input)
    private let tapBlurEffectView = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("MapViewController Error!")
    }
    
    override func loadView() {
        
        let mapID = GMSMapID(identifier: "42619687bc36aafd")
        mapView = GMSMapView(frame: .zero, mapID: mapID, camera: camera)
        self.view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        makeMarker()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first,
           touch.view == self.blurEffectView {
            self.tapBlurEffectView.accept(Void())
        }
    }
}

// MARK: - Bind
private extension MapViewController {
    
    func bind() {
        
        output.isVisible
            .asDriver()
            .drive { [weak self] state in
                self?.setSideBarViewLayout(isVisible: state)
            }
            .disposed(by: disposeBag)
        
        output.currentUserLocation
            .asDriver()
            .drive { coordinator in
                self.move(at: coordinator)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Custom Methods
private extension MapViewController {

    func setLocation() {
        
        mapView.isMyLocationEnabled = true
    }
    
    func makeMarker() {
        
        let mapCenter = CLLocationCoordinate2DMake(37.57039821, 126.98914393)
        let marker = GMSMarker(position: mapCenter)
        marker.icon = FogImage.pinInactive
        marker.map = mapView
    }
    
    func setSideBarViewLayout(isVisible: Bool = false) {
        
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
}

private extension MapViewController {

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
