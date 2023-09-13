//
//  QuitAPIService.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/09/13.
//

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
            .map { _ in () }
    }
}
