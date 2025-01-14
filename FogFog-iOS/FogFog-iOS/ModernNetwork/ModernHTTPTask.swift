//
//  ModernHTTPTask.swift
//  FogFog-iOS
//
//  Created by MEGA_Mac on 1/14/25.
//

import Foundation

enum ModernHTTPTask {
    case query(_ query: [String: Any])
    case queryBody(_ query: [String: Any], _ body: [String: Any])
    case requestBody(_ body: [String: Any])
    case requestPlain
}
