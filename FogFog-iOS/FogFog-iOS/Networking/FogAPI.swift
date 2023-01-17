//
//  FogAPI.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/17.
//

import Foundation

import Moya

enum FogDomain {
    case auth(path: String)
    case maps
    case users(path: String)
}

extension FogDomain {
    var url: String {
        switch self {
        case let .auth(path):
            return "/auth/\(path)"
        case .maps:
            return "/maps"
        case let .users(path):
            return "/users/\(path)"
        }
    }
}

protocol FogAPI: TargetType {
    var domain: FogDomain { get }
    var urlPath: String { get }
    var error: [Int: NetworkError]? { get }
}

extension FogAPI {
    var baseURL: URL {
        return URL(string: "http://fogfogdev-env-1.eba-9u3ghscu.ap-northeast-2.elasticbeanstalk.com")!
    }
    
    var path: String {
        return domain.url + urlPath
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
}
