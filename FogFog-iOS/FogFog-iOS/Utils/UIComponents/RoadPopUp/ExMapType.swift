//
//  ExMapType.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import Foundation

enum ExMapType: Int, CaseIterable {
    case kakao
    case google
    case naver
    
    var title: String {
        switch self {
        case .kakao:    return "카카오맵"
        case .google:   return "구글지도"
        case .naver:    return "네이버지도"
        }
    }
}
