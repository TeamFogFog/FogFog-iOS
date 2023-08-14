//
//  UserAPI.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/22.
//

import Moya

enum UserAPI {
    case preferredMap(userId: Int, mapId: Int)
    case withdrawal(userId: String)
    case getNickname(userId: Int)
    case editNickname(userId: Int, nickname: String)
}

extension UserAPI: FogAPI {
    
    var domain: FogDomain {
        return .users
    }
    
    var urlPath: String {
        switch self {
        case let .preferredMap(userId, _):
            return "/\(userId)/preferred-map"
        case .withdrawal(let userId):
            return "/\(userId)"
        case .getNickname(let userId), .editNickname(let userId, _):
            return "/\(userId)/nickname"
        }
    }
    
    var method: Method {
        switch self {
        case .preferredMap, .editNickname:
            return .patch
        case .withdrawal:
            return .delete
        case .getNickname:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .preferredMap(_, mapId):
          return ["preferredMap": mapId]
          
        case .withdrawal, .getNickname:
            return nil
        case .editNickname(_, let nickname):
            return ["nickname": nickname]
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .preferredMap, .withdrawal, .getNickname, .editNickname:
            return nil
        /*
         case .nickname:
            return [403: .unauthorized]
         */
        }
    }
}
