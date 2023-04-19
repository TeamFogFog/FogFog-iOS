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
    
    private init() {}
    
    // 유저 닉네임 조회
    func getUserNickname(userId: Int) -> Single<NicknameResponseModel?> {
        return provider.request(.getNickname(userId: userId))
            .map(NicknameResponseModel.self)
    }
}
