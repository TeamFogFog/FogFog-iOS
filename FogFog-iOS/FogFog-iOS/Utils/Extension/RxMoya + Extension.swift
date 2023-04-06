//
//  RxMoya + Extension.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/04/04.
//

import Foundation

import Moya
import RxSwift

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }

    /// Wrap to common response
    /// - Common response로 감싼 객체로 매핑해주는 메소드
    func map<Response: Decodable>(
        _ type: Response.Type
    ) -> PrimitiveSequence<Trait, CommonResponse<Response>> {
        return map(CommonResponse<Response>.self, using: decoder)
    }

    /// Map to pure
    /// - Pure data로 매핑해주는 메소드(아래 설명 참조)
    /// - 옵셔널 타입으로 반환합니다.
    /*
    - statusCode
    - success
    - message
    - data? <- Pure data in our service
    */
    func map<Response: Decodable>(
        _ type: Response.Type
    ) -> PrimitiveSequence<Trait, Response?> {
        return map(Response.self).map { $0.data }
    }
}
