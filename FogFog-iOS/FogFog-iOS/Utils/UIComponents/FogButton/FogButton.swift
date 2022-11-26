//
//  FogButton.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import UIKit

final class FogButton: BaseView {
    
    // MARK: UI
    private let leftImageView = UIImageView()
    private let titleLabel = UILabel()
    lazy var button = UIButton()
    
    // MARK: Properties
    var style: FogButtonStyle {
        didSet { setAppearance(style) }
    }

    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    var image: UIImage? {
        get { leftImageView.image }
        set { leftImageView.image = newValue }
    }
    
    // MARK: Init
    init(frame: CGRect = .zero, style: FogButtonStyle = .normal) {
        self.style = style
        super.init(frame: frame)
        setAppearance(style)
    }
    
    // MARK: Setup UI
    override func setStyle() {
        leftImageView.do {
            $0.contentMode = .scaleAspectFill
        }
    }
    
    override func setLayout() {
        addSubviews([leftImageView, titleLabel, button])
        
        leftImageView.snp.makeConstraints {
            $0.leading.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: Private Methods
extension FogButton {
    
    private func setAppearance(_ style: FogButtonStyle) {
        layer.borderWidth = 1.5
        layer.borderColor = style.borderColor.cgColor
        backgroundColor = style.backgroundColor
        titleLabel.textColor = style.titleColor
        titleLabel.font = style.font
        leftImageView.image = style.leftImage
    }
}
