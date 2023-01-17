//
//  NetworkEnv.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/17.
//

import Foundation

enum NetworkEnv {
    static let baseURL = "http://fogfogdev-env-1.eba-9u3ghscu.ap-northeast-2.elasticbeanstalk.com"
}

extension NetworkEnv {
    
    enum HTTPHeaderFields {
        static let `default`: [String: String] = ["Content-Type": "application/json"]
    }
}
