//
//  FogNavigationView.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/24.
//

import UIKit

import SnapKit
import Then

final class FogNavigationView: BaseView {

    // MARK: Properties
    private lazy var titleLabel = UILabel()
    private lazy var backButton = UIButton()
    
    // MARK: UI
    override func setStyle() {
        backgroundColor = .white
        
        titleLabel.do {
            $0.textColor = .grayGray2
            $0.font = .pretendardB(16)
            $0.textAlignment = .center
        }
        
        backButton.do {
            $0.setImage(FogImage.btnBack, for: .normal)
        }
    }
    
    override func setLayout() {
        self.addSubviews([titleLabel, backButton])
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(21)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
    }
}

// MARK: - Custom Methods
extension FogNavigationView {
    
    /// 타이틀 설정 메서드
    func setTitleLabel(title: String) {
        titleLabel.text = title
    }
}
