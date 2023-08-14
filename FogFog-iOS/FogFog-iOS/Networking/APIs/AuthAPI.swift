//
//  AuthAPI.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/30.
//

import Moya

struct SignInRequestDTO: Codable {
    let socialType: String
    let kakaoAccessToken: String?
    let idToken: String?
    let code: String?
}

struct SignInResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
    let id: Int
}

enum AuthAPI {
    case signIn(request: SignInRequestDTO)
}

extension AuthAPI: FogAPI {
    
    var domain: FogDomain {
        return .auth
    }
    
    var urlPath: String {
        switch self {
        case .signIn:
            return "/signin"
        }
    }
    
    var method: Method {
        switch self {
        case .signIn:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case let .signIn(request):
            return [
                "socialType": request.socialType,
                "kakaoAccessToken": request.kakaoAccessToken ?? "",
                "idToken": request.idToken ?? "",
                "code": request.code ?? ""
            ]
        }
    }
    
    var error: [Int: NetworkError]? {
        switch self {
        case .signIn:
            return nil
        }
    }
}
