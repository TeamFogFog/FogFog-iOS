//
//  CommonResponse.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/17.
//

import Foundation

/// Generic Response
struct CommonResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let success: Bool
    let data: T?
    
    enum CodingKeys: CodingKey {
        case statusCode
        case message
        case success
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.statusCode = (try? container.decode(Int.self, forKey: .statusCode)) ?? 500
        self.message = (try? container.decode(String.self, forKey: .message)) ?? ""
        self.success = (try? container.decode(Bool.self, forKey: .success)) ?? false
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
    }
}
