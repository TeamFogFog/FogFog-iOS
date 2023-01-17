//
//  Networking.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/17.
//

import RxSwift
import RxMoya
import Moya

protocol Networking {
    associatedtype API: FogAPI
    
    func request(_ api: API) -> Single<Response>
}

final class NetworkProvider<API: FogAPI>: Networking {
    
    private let provider = MoyaProvider<API>(plugins: [])
    
    func request(
        _ api: API
    ) -> Single<Response> {
        let requestString = "\(api.urlPath)"
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    print(value)
                },
                onError: { error in
                    print(error)
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
