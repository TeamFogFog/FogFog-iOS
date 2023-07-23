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
   
    private var mapView = GMSMapView()
    private var myMarker = GMSMarker()
    
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

        makeMarker()
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
            tapMenuButton: navigationView.menuButtonObservable,
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
        
        output.currentUserLocation
            .asDriver()
            .drive { coordinator in
                self.move(at: coordinator)
            }
            .disposed(by: disposeBag)
    }
}
// MARK: - Custom Methods
extension MapViewController {
    
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

private extension MapViewController {
    func setLocation() {
        mapView.isMyLocationEnabled = true
    }
    
    func makeMarker() {
        let mapCenter = CLLocationCoordinate2DMake(37.57039821, 126.98914393)
        let marker = GMSMarker(position: mapCenter)
        marker.icon = FogImage.placeMarker
        marker.map = mapView
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
