//
//  QuitAPIService.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/09/13.
//

import Foundation

import Moya
import RxSwift

protocol QuitAPIServiceType {
    func quit(id: Int) -> Single<Void>
}

final class QuitAPIService: QuitAPIServiceType {
    // MARK: - Rx
    private let disposeBag = DisposeBag()
    
    // MARK: - Property
    private let provider = NetworkProvider<AuthAPI>()
    
    // MARK: - Initialization
    init() {}
    
    /// 회원탙퇴를 진행합니다.
    func quit(id: Int) -> Single<Void> {
        return provider
            .request(.quit(id: id))
            .do(onSuccess: { [weak self] _ in
                UserDefaults.userId  = nil    // 유저 아이디 삭제
                self?.removeAllKeychainKeys() // 키체인 값 삭제
            })
            .map { _ in () }
    }
    
    // 회원탈퇴 시에 모든 키체인 값을 제거합니다.
    func removeAllKeychainKeys() {
        Keychain.delete(key: Keychain.Keys.accessToken)
        Keychain.delete(key: Keychain.Keys.refreshToken)
        Keychain.delete(key: Keychain.Keys.socialType)
    }
}
