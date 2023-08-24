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

protocol Reissueable {
    func reissueAuthentication() -> Single<SignInResponseDTO?>
}

final class ReissueAPIService: Networking, Reissueable {

    // MARK: - Type Alias
    typealias API = AuthAPI
    
    // MARK: - Property
    private let provider = NetworkProvider<API>()
    
    // MARK: - Custom Methods
    
    // 401 error 시 토큰 재발급 Request
    func reissueAuthentication() -> Single<SignInResponseDTO?> {
        return provider
            .request(.reissueToken)
            .map(SignInResponseDTO.self)
    }
}
