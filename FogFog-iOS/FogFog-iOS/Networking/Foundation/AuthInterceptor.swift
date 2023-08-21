//
//  AuthInterceptor.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/08/18.
//

import Foundation

import Alamofire
import RxSwift

final class AuthInterceptor: RequestInterceptor {
    
    private let disposeBag = DisposeBag()
 
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let accessToken = Keychain.read(key: Keychain.Keys.accessToken),
              let refreshToken = Keychain.read(key: Keychain.Keys.refreshToken)
        else {
            completion(.success(urlRequest))
            return
        }
        
        // request header 설정
        var urlRequest = urlRequest
        urlRequest.headers.add(.authorization(bearerToken: accessToken))
        if let urlString = urlRequest.url?.absoluteString, urlString.hasSuffix("/reissue/token") {
            urlRequest.headers.add(.authorization(bearerToken: refreshToken))
        }
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for _: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401
        else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        // 토큰 재발급 요청
        ReissueAPIService.shared.reissueAuthentication()
            .subscribe(onSuccess: { result in
                Keychain.create(key: Keychain.Keys.accessToken, data: result?.accessToken ?? "")
                Keychain.create(key: Keychain.Keys.refreshToken, data: result?.refreshToken ?? "")
                completion(.retry)
            }, onFailure: { error in
                // TODO: 토큰 재발급 실패 - 로그인 화면으로 전환
                completion(.doNotRetryWithError(error))
            })
            .disposed(by: disposeBag)
    }
}
