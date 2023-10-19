//
//  AppDelegate.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import GoogleMaps
import RxKakaoSDKAuth
import KakaoSDKAuth
import RxKakaoSDKCommon
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: 구글 맵 설정
        GMSServices.provideAPIKey(Bundle.main.apiKey)
        
        // MARK: 카카오 SDK 초기화
        RxKakaoSDK.initSDK(appKey: Config.kakaoNativeAppKey)
        
        // MARK: 키체인 정보 초기화
        resetKeychainAtFirstLaunch()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.rx.handleOpenUrl(url: url)
        }

        return false
    }
    
    // 첫 실행 시 키체인 정보 초기화하는 메서드
    private func resetKeychainAtFirstLaunch() {
        let quitApiService = QuitAPIService()
        
        if UserInfo.isFirstLaunch {
            quitApiService.removeAllKeychainKeys()
        }
    }
}

