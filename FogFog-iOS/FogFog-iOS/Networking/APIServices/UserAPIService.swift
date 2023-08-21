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
    
    // MARK: - Type Alias
    typealias API = UserAPI
    
    // MARK: - Property
    private let provider = NetworkProvider<API>()
    
    // MARK: - Instance
    static let shared = UserAPIService()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Custom Methods
    
    // 유저 닉네임 조회
    func getUserNickname(userId: Int) -> Single<NicknameResponseModel?> {
        return provider.request(.getNickname(userId: userId))
            .map(NicknameResponseModel.self)
    }
    
    // 유저 닉네임 수정
    func editUserNickname(userId: Int, nickname: String) -> Single<NicknameResponseModel?> {
        return provider.request(.editNickname(userId: userId, nickname: nickname))
            .map(NicknameResponseModel.self)
    }
  
    // 선호 지도 설정
    func setPreferredMap(userId: Int, mapId: Int) -> Single<EmptyData?> {
      return provider
          .request(.preferredMap(userId: userId, mapId: mapId))
          .map(EmptyData.self)
    }
}
