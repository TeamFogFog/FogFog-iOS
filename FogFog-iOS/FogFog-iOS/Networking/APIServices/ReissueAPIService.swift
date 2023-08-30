//
//  ReissueAPIService.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/08/20.
//

import Foundation

import Moya
import RxCocoa
import RxSwift

final class ReissueAPIService: Networking {

    // MARK: - Type Alias
    typealias API = AuthAPI
    
    // MARK: - Property
    private let provider = NetworkProvider<API>()
    
    // MARK: - Instance
    static let shared = ReissueAPIService()
    
    // MARK: - Initialization
    private init() {}
    
    // MARK: - Custom Methods
    
    // 401 error 시 토큰 재발급 Request
    func reissueAuthentication() -> Single<SignInResponseDTO?> {
        return provider
            .request(.reissueToken)
            .map(SignInResponseDTO.self)
    }
}
