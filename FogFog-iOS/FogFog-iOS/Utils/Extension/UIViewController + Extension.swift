//
//  UIViewController + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit.UIViewController

extension UIViewController {
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}
