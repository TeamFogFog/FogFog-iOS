//
//  CommonResponse.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/17.
//

import Foundation

struct CommonResponse<T: Decodable>: Decodable {
    let statusCode: Int
    let message: String
    let success: Bool
    let data: T?
}
