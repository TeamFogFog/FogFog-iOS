//
//  NavigationView.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/15.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class NavigationView: UIView {
    
    private lazy var logoImageView = UIImageView()
    fileprivate lazy var menuButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        
        self.backgroundColor = .white
        
        logoImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = FogImage.logo
        }
        
        menuButton.do {
            $0.setImage(FogImage.hamburger, for: .normal)
        }
        
        [logoImageView, menuButton]
            .forEach { addSubview($0) }
    }
    
    private func setupConstraints() {
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(12)
            $0.width.equalTo(102)
            $0.height.equalTo(27)
        }
        
        menuButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalTo(logoImageView.snp.centerY)
            $0.size.equalTo(30)
        }
    }
}

extension Reactive where Base: NavigationView {
    var menuButtonTapped: ControlEvent<Void> {
        base.menuButton.rx.tap
    }
}
