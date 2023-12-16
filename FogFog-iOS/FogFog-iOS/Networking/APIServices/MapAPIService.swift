//
//  MapAPIService.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/09/13.
//

import Moya
import RxSwift

protocol MapAPIServiceType {
    func fetchPlaceAll(coordinates: CoordinatesRequest) -> Single<SmokingAreaResponseEntity?>
    func fetchPlaceDetail(id: Int, coordinates: CoordinatesRequest) -> Single<SmokingAreaDetailResponseEntity?>
}

final class MapAPIService: MapAPIServiceType {
    private let provider = MoyaProvider<MapAPI>()
    
    public init() {}
    
        func fetchPlaceAll(coordinates: CoordinatesRequest) -> Single<SmokingAreaResponseEntity?> {
        return provider.rx.request(.fetchPlace(coordinates)).map(SmokingAreaResponseEntity.self)
    }

    func fetchPlaceDetail(id: Int, coordinates: CoordinatesRequest) -> Single<SmokingAreaDetailResponseEntity?> {
        return provider.rx.request(.fetchPlaceDetail(id, coordinates)).map(SmokingAreaDetailResponseEntity.self)
    }
}
