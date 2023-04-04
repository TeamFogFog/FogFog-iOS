//
//  UserAPIService.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/03/26.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

class UserAPIService: Networking {
    typealias API = UserAPI
    
    static let shared = UserAPIService()
    var provider = NetworkProvider<API>()
    
    func getUserNickname(userId: Int) -> Single<NicknameResModel> {
        return provider.request(.getNickname(userId: userId))
            .map { response in
                try JSONDecoder().decode(NicknameResModel.self, from: response.data)
            }
    }
}
