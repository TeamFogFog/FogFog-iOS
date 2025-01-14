//
//  JSONResponseDecoder.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

import Foundation

/// 데이터 디코딩을 위한 프로토콜
/// - Note: 데이터 디코딩 추상화
protocol ResponseDecoding {
   func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

/// JSON 데이터 디코딩을 담당하는 구조체
/// - Note: ResponseDecoding 프로토콜 기본 구현체
struct JSONResponseDecoder: ResponseDecoding {
   private let decoder: JSONDecoder
   
   init(decoder: JSONDecoder = JSONDecoder()) {
       self.decoder = decoder
   }
   
   func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
       try decoder.decode(type, from: data)
   }
}
