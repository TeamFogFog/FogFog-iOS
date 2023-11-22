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
    private let networkProvider: MapAPIServiceType
    
    init(coordinator: MapCoordinator?,
         locationService: LocationService,
         networkProvider: MapAPIServiceType) {
        self.coordinator = coordinator
        self.locationService = locationService
        self.networkProvider = networkProvider
    }
    
    struct Input {
        let viewDidLoad: ControlEvent<Void>
        let viewWillAppear: ControlEvent<Bool>
        let tapMenuButton: ControlEvent<Void>
        let tapBlurEffectView: Signal<Void>
        let tapSettingButton: ControlEvent<Void>
        let tapResearchButton: Observable<CLLocationCoordinate2D>
    }
    
    struct Output {
        let userNickname: BehaviorSubject<String>
        let isVisible: Driver<Bool>
        let didSettingButtonTapped: Signal<Void>
        let currentUserLocation: Driver<CLLocationCoordinate2D>
        let smokingAreas: Driver<[CLLocationCoordinate2D]>
        let smokingAreasCount: Driver<Int>
    }
    
    let userNickname = BehaviorSubject<String>(value: UserDefaults.nickname ?? "")
    
    func transform(input: Input) -> Output {
        let sideBarState = PublishRelay<Bool>()
        let didSettingButtonTapped = PublishRelay<Void>()
        let currentUserLocation = PublishRelay<CLLocationCoordinate2D>()
        let coordinate = BehaviorRelay<[CLLocationCoordinate2D]>(value: [])
        let smokingAreasCount = PublishRelay<Int>()
        let output = Output(userNickname: userNickname,
                            isVisible: sideBarState.asDriver(onErrorJustReturn: false),
                            didSettingButtonTapped: didSettingButtonTapped.asSignal(),
                            currentUserLocation: currentUserLocation.asDriver(onErrorJustReturn: CLLocationCoordinate2D(latitude: 20, longitude: 20)),
                            smokingAreas: coordinate.asDriver(onErrorJustReturn: [CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)]),
                            smokingAreasCount: smokingAreasCount.asDriver(onErrorJustReturn: 0))
        
        input.viewDidLoad
            .subscribe(with: self, onNext: { owner, _ in
                owner.checkAuthorization()
                owner.observeUserLocation()
                if UserDefaults.nickname == nil {
                    owner.getUserNicknameAPI(userId: UserDefaults.userId ?? -1)
                }
                
            })
            .disposed(by: disposeBag)
        
        /*
         viewDidLoad() 실행시, take(1)로 현재 위치의 위도 경도를 통해 호출
         */
        locationService.location
            .asObservable()
            .take(1)
            .flatMap { res in
                return self.networkProvider.fetchPlaceAll(coordinates: CoordinatesRequest(lat: res.first!.coordinate.latitude, long: res.first!.coordinate.longitude))
            }
            .subscribe(onNext: { res in
                if let res {
                    for area in res.areas {
                        coordinate.accept([CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude)])
                    }
                    dump(res)
                }
            })
            .disposed(by: disposeBag)
        
        /*
         이게 문제인 것 같은데 검색 버튼 클릭하면 현재 화면의 위도, 경도의 중앙값으로 검색
         */
        input.tapResearchButton
            .asObservable()
            .skip(1)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { coordinate in
                let roundedLatitude = Double(String(format: "%.6f", coordinate.latitude))!
                let roundedLongitude = Double(String(format: "%.6f", coordinate.longitude))!
                print("위경도", roundedLatitude)
                return self.networkProvider.fetchPlaceAll(coordinates: CoordinatesRequest(lat: 37.628534603279185, long: 127.07641601558362))
            }
            .subscribe(onNext: { res in
                if let res {
                    for area in res.areas {
                        coordinate.accept([CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude)])
                    }
                    smokingAreasCount.accept(res.total)
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
                owner.coordinator?.connectSettingCoordinator()
            })
            .disposed(by: disposeBag)
        
        locationService.location
            .asObservable()
            .take(1)
            .flatMap { res in
                return self.networkProvider.fetchPlaceAll(coordinates: CoordinatesRequest(lat: res.first!.coordinate.latitude, long: res.first!.coordinate.longitude))
            }
            .subscribe(onNext: { res in
                if let res {
                    for area in res.areas {
                        coordinate.accept([CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude)])
                    }
                    dump(res)
                }
            })
            .disposed(by: disposeBag)

        input.tapResearchButton
            .asObservable()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { coordinate in
                let roundedLatitude = Double(String(format: "%.4f", coordinate.latitude))!
                let roundedLongitude = Double(String(format: "%.4f", coordinate.longitude))!
                print("위도", roundedLatitude)
                print("경도", roundedLongitude)
                return self.networkProvider.fetchPlaceAll(coordinates: CoordinatesRequest(lat: roundedLatitude, long: roundedLongitude))
            }
            .subscribe(onNext: { res in
                if let res {
                    for area in res.areas {
                        coordinate.accept([CLLocationCoordinate2D(latitude: area.latitude, longitude: area.longitude)])
                    }
                    smokingAreasCount.accept(res.total)
                }
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
            .take(1)
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
//                UserDefaults.nickname = result?.nickname
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
