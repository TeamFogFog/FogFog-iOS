//
//  UserDefaultsKey.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/10/17.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case nickname
    case userId
    case isFirstLaunch
}

// UserDefaults에 저장된 모든 유저 정보를 제거하는 메서드
func removeAllUserDefaulsKeys() {
    UserDefaultsKey.allCases
        .forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
}
