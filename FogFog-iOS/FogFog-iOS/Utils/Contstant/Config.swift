//
//  Config.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/05/29.
//

import Foundation

enum Config {
    
    static var kakaoNativeAppKey: String {
        guard let key = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String else {
            assertionFailure("KAKAO_NATIVE_APP_KEY could not found.")
            return ""
        }
        return key
    }
}
