//
//  UserDefaults + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/10/22.
//

import Foundation

extension UserDefaults {
    
    @UserDefault<String>(key: UserDefaultsKey.nickname.rawValue, defaultValue: "")
    static var nickname
    
    @UserDefault<Int>(key: UserDefaultsKey.userId.rawValue, defaultValue: -1)
    static var userId
    
    @UserDefault<Bool>(key: UserDefaultsKey.isFirstLaunch.rawValue, defaultValue: true)
    static var isFirstLaunch
}
