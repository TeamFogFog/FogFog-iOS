//
//  FogAPI.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/17.
//

import Foundation

import Moya

/// FogFog 도메인
enum FogDomain {
    case auth
    case maps
    case users
}

extension FogDomain {
    /// 도메인에 따른 기본 url
    var url: String {
        switch self {
        case .auth:
            return "/auth"
        case .maps:
            return "/maps"
        case .users:
            return "/users"
        }
    }
}

/// FogFog API가 기본적으로 준수해야 하는 정보
///
/// domain : FogFog Domain(ex. users, maps, auth ...)
/// urlPath : Domain 뒤에 붙는 상세 경로(path)
/// error : 상태코드에 따른 NetworkError 구분하는데 사용되는 딕셔너리
/// parameters : Request에 사용될 Paramter - 기본적으로 JSONEncoding 방식으로 인코딩
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
    
    var headers: [String: String]? {
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
