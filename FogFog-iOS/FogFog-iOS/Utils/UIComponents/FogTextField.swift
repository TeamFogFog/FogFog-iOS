//
//  FogTextField.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/25.
//

import UIKit

import SnapKit
import Then

final class FogTextField: UITextField {

    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UI
    private func setStyle() {
        setClearButton()
        setBoderColor(color: .grayGray9)
        self.makeRounded(cornerRadius: 12)
        self.addShadow(offset: CGSize(width: 0, height: 2), color: .shadowGray2, opacity: 0.14, radius: 17)
        self.addLeftPadding(19)
        self.font = .pretendardB(18)
        self.textColor = .grayGray1
        self.layer.borderWidth = 1
        self.backgroundColor = .white
    }
}

// MARK: - Custom Methods
extension FogTextField {
    
    /// boderColor 설정 메서드
    func setBoderColor(color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    
    /// Placeholder 설정 메서드
    func setPlaceHolderText(placeholder: String) {
        self.placeholder = placeholder
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.grayGray7, .font: UIFont.pretendardR(18)])
    }
}
