//
//  NetworkError.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/01/15.
//

import Foundation

@frozen
enum NetworkError: Int {
    case invalidRequest = 400
    case invalidToken   = 401
    case unauthorized   = 403
    case notFound       = 404
    case serverError    = 500
}
