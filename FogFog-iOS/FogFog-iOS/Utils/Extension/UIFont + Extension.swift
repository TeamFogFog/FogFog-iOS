//
//  UIFont + Extension.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/15.
//

import UIKit.UIFont

extension UIFont {
    
    static func PretendardEL(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.extraLight.rawValue, size: size)!
    }
    
    static func PretendardL(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.light.rawValue, size: size)!
    }
    
    static func PretendardR(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.regular.rawValue, size: size)!
    }
    
    static func PretendardM(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.medium.rawValue, size: size)!
    }
    
    static func PretendardEB(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.extraBold.rawValue, size: size)!
    }
    
    static func PretendardB(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.bold.rawValue, size: size)!
    }
    
    static func PretendardSB(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.semibold.rawValue, size: size)!
    }
    
    static func PretendardT(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.thin.rawValue, size: size)!
    }
    
    static func PretendardBL(_ size: CGFloat) -> UIFont {
        return UIFont(name: FogFont.black.rawValue, size: size)!
    }
}
