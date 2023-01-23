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
    
    func request(_ api: API, file: StaticString, function: StaticString, line: UInt) -> Single<Response>
}

extension Networking {
    
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        self.request(api, file: file, function: function, line: line)
    }
}

final class NetworkProvider<API: FogAPI>: Networking {

    private let provider: MoyaProvider<API>
    
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<API>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        self.provider = MoyaProvider(session: session, plugins: plugins)
    }

    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(api.urlPath)"
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { response in
                    print("SUCCESS: \(requestString) (\(response.statusCode))")
                },
                onError: { error in
                    if let error = error as? MoyaError {
                        switch error {
                        case .statusCode(let response):
                            if response.statusCode == 401 {
                                // Unauthorized - token refresh
                            }
                        default: break
                        }
                    }
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
