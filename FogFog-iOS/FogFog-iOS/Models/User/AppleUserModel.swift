//
//  AppleUserModel.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/07/13.
//

import Foundation

/*
 애플 로그인 시 사용되는 유저 데이터
- id: 애플 idToken(로그인/회원가입 시 사용)
- code: authorizationCode
- email: 이메일
 */
struct AppleUserModel {
    var id: String
    var code: String
    var email: String
}
