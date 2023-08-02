//
//  MakeNicknameViewType.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/08/03.
//

import Foundation

// 닉네임 설정 뷰 타입
enum MakeNicknameViewType {
    case create
    case edit
    
    var title: String {
        switch self {
        case .create: return "닉네임 설정"
        case .edit: return "닉네임 수정"
        }
    }
}
