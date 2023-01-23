//
//  SettingListTableViewCell.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit

import SnapKit
import Then

final class SettingListTableViewCell: BaseTableViewCell {
    
    // MARK: Properties
    private let titleLabel = UILabel()

    // MARK: UI
    override func setStyle() {
        titleLabel.do {
            $0.font = .pretendardM(16)
            $0.textColor = .grayBlack
        }
    }
    
    override func setLayout() {
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16)
        }
    }
       
    // MARK: Custom Methods
    func setData(title: String) {
        titleLabel.text = title
    }
}
