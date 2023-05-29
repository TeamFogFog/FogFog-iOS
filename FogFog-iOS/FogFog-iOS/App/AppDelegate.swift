//
//  AppDelegate.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import GoogleMaps
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - 구글 맵 설정
        GMSServices.provideAPIKey(Bundle.main.apiKey)
        
        // MARK: - 카카오 SDK 초기화
        RxKakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        return true
    }
}

