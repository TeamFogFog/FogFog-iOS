//
//  SettingTitleTableViewCell.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit

import SnapKit
import Then

final class SettingTitleTableViewCell: BaseTableViewCell {
    
    // MARK: Properties
    private let titleLabel = UILabel()
    let lineView = UIView()
    
    // MARK: UI
    override func setStyle() {
        titleLabel.do {
            $0.font = .pretendardM(12)
            $0.textColor = .grayGray6
        }
        
        lineView.backgroundColor = .grayGray10
    }
    
    override func setLayout() {
        contentView.addSubviews([lineView, titleLabel])
        
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(26)
            $0.leading.bottom.equalToSuperview().inset(16)
        }
    }
       
    // MARK: Custom Methods
    func setData(title: String) {
        titleLabel.text = title
    }
}
