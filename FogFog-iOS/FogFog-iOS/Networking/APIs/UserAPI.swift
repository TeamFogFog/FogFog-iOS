//
//  UserAPI.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/22.
//

import Moya

enum UserAPI {
    case preferredMap(userId: String)
    case withdrawal(userId: String)
}

extension UserAPI: FogAPI {
    
    var domain: FogDomain {
        return .users
    }
    
    var urlPath: String {
        switch self {
        case .preferredMap(let userId):
            return "/\(userId)/preffered-map"
        case .withdrawal(let userId):
            return "/\(userId)"
        }
    }
    
    var method: Method {
        switch self {
        case .preferredMap:
            return .patch
        case .withdrawal:
            return .delete
        }
    }
    
    var parameters: [String: String]? {
        switch self {
        case .preferredMap, .withdrawal:
            return nil
        }
    }
    
    var error: [Int : NetworkError]? {
        switch self {
        case .preferredMap:
            return nil
        case .withdrawal:
            return nil
        /*
         case .nickname:
            return [403: .unauthorized]
         */
        }
    }
}
