//
//  UserDefaults + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/10/22.
//

import Foundation

extension UserDefaults {
    
    // MARK: - Properties
    @UserDefault<String>(key: UserDefaultsKey.nickname.rawValue, defaultValue: "")
    static var nickname
    
    @UserDefault<Int>(key: UserDefaultsKey.userId.rawValue, defaultValue: -1)
    static var userId
    
    @UserDefault<Bool>(key: UserDefaultsKey.isFirstLaunch.rawValue, defaultValue: true)
    static var isFirstLaunch
    
    // MARK: - Custom Methods
    
    // UserDefaults에 저장된 모든 유저 정보를 제거하는 메서드
    func removeAllUserDefaulsKeys() {
        UserDefaultsKey.allCases
            .forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
    }
}
