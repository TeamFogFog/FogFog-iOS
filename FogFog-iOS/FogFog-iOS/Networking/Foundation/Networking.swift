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
    private let interceptor: AuthInterceptor
    private let reissueService = ReissueAPIService()
    
    init(plugins: [PluginType] = []) {
        self.interceptor = AuthInterceptor(reissueAuth: reissueService)
        let session = Session(interceptor: interceptor)
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
                onError: { _ in
                    print("ERROR: \(requestString)")
                },
                onSubscribed: {
                    print("REQUEST: \(requestString)")
                }
            )
    }
}
