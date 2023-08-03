//
//  UserDefaults + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/05/31.
//

import Foundation

extension UserDefaults {
    
    @UserDefault<String>(key: "nickname")
    static var nickname
    
    @UserDefault<Int>(key: "userId")
    static var userId
}
