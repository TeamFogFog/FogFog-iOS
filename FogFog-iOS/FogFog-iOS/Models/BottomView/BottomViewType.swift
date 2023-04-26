//
//  BottomViewType.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/04/20.
//

import Foundation

enum BottomViewType {
    case cardView
    case messageView
    
    var view: any Presentable {
        switch self {
        case .cardView:
            return SmokingAreaCardView()
        
        case .messageView:
            return SmokingAreaMessageView()
        }
    }
}
