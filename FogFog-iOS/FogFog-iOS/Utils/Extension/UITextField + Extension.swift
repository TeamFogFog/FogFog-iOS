//
//  UITextField + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/25.
//

import UIKit.UITextField

extension UITextField {
    
    /// UITextField 왼쪽에 여백 주는 메서드
    func addLeftPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    /// UITextField 오른쪽에 여백 주는 메서드
    func addRightPadding(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    /// clearButton 설정 메서드
    func setClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(FogImage.deleteTextIcon, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 0, width: 18, height: 18)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: 18))
        rightView.addSubview(clearButton)
        
        self.rightView = rightView
        self.rightViewMode = .whileEditing
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
    }
}
