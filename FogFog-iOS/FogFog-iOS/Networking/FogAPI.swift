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
    case users
}

extension FogDomain {
    var url: String {
        switch self {
        case let .auth(path):
            return "/auth/\(path)"
        case .maps:
            return "/maps"
        case .users:
            return "/users"
        }
    }
}

protocol FogAPI: TargetType {
    var domain: FogDomain { get }
    var urlPath: String { get }
    var error: [Int: NetworkError]? { get }
    var parameters: [String: String]? { get }
}

extension FogAPI {
    var baseURL: URL {
        return URL(string: NetworkEnv.baseURL)!
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
            return NetworkEnv.HTTPHeaderFields.default
        }
    }

    var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
        return .requestPlain
    }
}
