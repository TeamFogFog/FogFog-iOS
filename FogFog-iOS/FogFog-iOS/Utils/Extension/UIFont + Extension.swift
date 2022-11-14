//
//  UIFont + Extension.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/15.
//

import UIKit.UIFont

extension UIFont {
    
    // 1안
    static func font(_ type: FogFont, ofSize size: CGFloat) -> UIFont {
        return UIFont(name: type.rawValue, size: size)!
    }
    
    
    // 2안
    static var fogB20: UIFont {
        return UIFont(name: FogFont.regular.rawValue, size: 20)!
    }
}
