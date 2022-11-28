//
//  UIView + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/18.
//

import UIKit

extension UIView {
    
    /// 다수의 뷰를 한번에 addSubview해주는 메서드
    func addSubviews(_ views: [UIView]) {
        
        views.forEach { self.addSubview($0) }
    }
    
    /// UIView 의 모서리가 둥근 정도를 설정하는 메서드
    func makeRounded(cornerRadius: CGFloat?) {
        
        if let cornerRadius = cornerRadius {
            self.layer.cornerRadius = cornerRadius
        } else {
            // cornerRadius 가 nil 일 경우의 default
            self.layer.cornerRadius = self.layer.frame.height / 2
        }
        self.layer.masksToBounds = true
    }
    
    /// gradient 설정 메서드
    func setGradient(_ color1: UIColor, _ color2: UIColor) {
        
        let gradient = CAGradientLayer()
        
        gradient.colors = [color1.cgColor, color2.cgColor]
        gradient.locations = [0.25, 0.7]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        
        layer.addSublayer(gradient)
    }
    
    /// UIView의 그림자를 설정하는 메서드
    func addShadow(offset: CGSize, color: UIColor, opacity: Float, radius: CGFloat) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
