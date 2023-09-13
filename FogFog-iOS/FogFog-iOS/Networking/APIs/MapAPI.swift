//
//  MapAPI.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/09/13.
//

import UIKit
import Moya

struct CoordinatesRequest: Equatable {
    let lat: CGFloat
    let long: CGFloat
}

enum MapAPI {
    case fetchPlace(CoordinatesRequest)
    case fetchPlaceDetail(Int, CoordinatesRequest)
}

extension MapAPI: TargetType {
    var baseURL: URL {
        return URL(string: NetworkEnv.baseURL)!
    }
    
    var path: String {
        switch self {
        case .fetchPlace:
            return "/maps"
        case .fetchPlaceDetail(let id, _):
            return "/maps/\(id)"
        }
    }
    
    var headers: [String: String]? {
        return .none
    }

    var method: Moya.Method {
        switch self {
        case .fetchPlace:
            return .get
        case .fetchPlaceDetail:
            return .get
        }
    }
    
    var task: Task {
        var params: [String: Any] = [:]
        switch self {
        case .fetchPlace(let coordinates):
            params["lat"] = coordinates.lat
            params["long"] = coordinates.long
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .fetchPlaceDetail(_, let coordinates):
            params["lat"] = coordinates.lat
            params["long"] = coordinates.long
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }
    }
}
