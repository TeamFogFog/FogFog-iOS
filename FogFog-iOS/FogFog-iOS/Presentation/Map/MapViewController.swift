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
    private var markersArray: [GMSMarker] = []
    private lazy var researchButton = UIButton()
    private lazy var sideBarView = SideBarView()
    private var blurEffectView: UIVisualEffectView!
    private let camera = GMSCameraPosition(latitude: 37.54330366639085, longitude: 127.04455548501139, zoom: 16)
    private var currentLocation = BehaviorRelay(value: CLLocationCoordinate2D(latitude: 0, longitude: 0))
    private var mapView = GMSMapView()
    private var myMarker = GMSMarker()
    private var viewModel: MapViewModel
    private let tapBlurEffectView = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    private let researchButtonTapRelay = PublishRelay<CLLocationCoordinate2D>()

    lazy var input = MapViewModel.Input(
        viewDidLoad: self.rx.viewDidLoad,
        viewWillAppear: self.rx.viewWillAppear,
        tapMenuButton: navigationView.rx.menuButtonTapped,
        tapBlurEffectView: tapBlurEffectView.asSignal(),
        tapSettingButton: sideBarView.rx.settingButtonTapped,
        tapResearchButton: researchButtonTapRelay.asObservable())
    lazy var output = viewModel.transform(input: input)
    
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
        self.makeMap()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        researchButton.do {
            $0.setTitle("현 지도에서 재검색", for: .normal)
            $0.backgroundColor = .fogBlue
            $0.titleLabel?.font = .pretendardL(15)
        }
    }
    
    override func setLayout() {
        view.addSubviews([navigationView, blurEffectView, sideBarView, researchButton])

        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(102)
            $0.leading.trailing.equalToSuperview()
        }
        
        researchButton.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(10)
            $0.width.equalTo(138.adjusted)
            $0.height.equalTo(40.adjustedH)
            $0.centerX.equalToSuperview()
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
    
    private func makeMap() {
        let mapID = GMSMapID(identifier: "42619687bc36aafd")
        output.currentUserLocation
            .asDriver()
            .drive { coordinates in
                self.currentLocation.accept(coordinates)
                self.move(at: coordinates)
            }
            .disposed(by: disposeBag)
        
        mapView = GMSMapView(frame: .zero, mapID: mapID, camera: GMSCameraPosition(latitude: currentLocation.value.latitude, longitude: currentLocation.value.longitude, zoom: 16))

        self.view = mapView
    }
    
    private func bind() {
        researchButton.rx.tap
            .map { CLLocationCoordinate2D(latitude: self.mapView.camera.target.latitude,
                                          longitude: self.mapView.camera.target.longitude)}
            .bind(to: researchButtonTapRelay)
            .disposed(by: disposeBag)

        researchButton.rx.tap
            .bind(onNext: { _ in
                self.removeMarkers()
            })
            .disposed(by: disposeBag)
        
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
                self.sideBarView.setNickname(result)
            })
            .disposed(by: disposeBag)

        output.currentUserLocation
            .asDriver()
            .drive { coordinates in
                self.currentLocation.accept(coordinates)
            }
            .disposed(by: disposeBag)
        
        output.smokingAreas
            .drive(onNext: { coords in
                for coord in coords {
                    let latitude = coord.latitude
                    let longitude = coord.longitude
                    let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    self.makeMarker(at: location)
                }
            })
            .disposed(by: disposeBag)
        
        output.smokingAreasCount
            .drive(onNext: { count in
                let toastView = FogToast()
                let message = count == 0 ? "주변에 흡역구역이 없습니다." : "주변에 \(count)개의 흡연구역이 있습니다."
                toastView.setContents(message)
                toastView.present(on: self)
                toastView.dismiss()
            })
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
    
    func makeMarker(at coordinate: CLLocationCoordinate2D) {
        let mapCenter = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        let marker = GMSMarker(position: mapCenter)
        let image = FogImage.pinActive.resizedImage(sizeImage: CGSize(width: 40.adjusted, height: 40.adjustedH))
        marker.icon = image
        marker.map = mapView
        markersArray.append(marker)
    }
    
    func removeMarkers() {
        for marker in markersArray {
            marker.map = nil
        }
        
        markersArray.removeAll()
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
