//
//  ModernEndpoint.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/8/25.
//

import Foundation

protocol ModernEndpoint {
    var path: String { get }
    var method: ModernHttpMethod { get }
    var parameters: [String: Any]? { get }
    var headers: [String: String]? { get }
}
