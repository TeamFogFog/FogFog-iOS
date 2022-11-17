//
//  UIFont + Extension.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/15.
//

import UIKit.UIFont

extension UIFont {
    
    static func pretendardEL(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.extraLight.rawValue, size: size)!
    }
    
    static func pretendardL(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.light.rawValue, size: size)!
    }
    
    static func pretendardR(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.regular.rawValue, size: size)!
    }
    
    static func pretendardM(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.medium.rawValue, size: size)!
    }
    
    static func pretendardEB(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.extraBold.rawValue, size: size)!
    }
    
    static func pretendardB(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.bold.rawValue, size: size)!
    }
    
    static func pretendardSB(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.semibold.rawValue, size: size)!
    }
    
    static func pretendardT(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.thin.rawValue, size: size)!
    }
    
    static func pretendardBL(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.black.rawValue, size: size)!
    }
}
