//
//  SettingNicknameTableViewCell.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class SettingNicknameTableViewCell: BaseTableViewCell {
    
    // MARK: Properties
    private let containerView = UIView()
    private let nicknameLabel = UILabel()
    private let editNicknameButton = UIButton()
    
    // MARK: UI
    override func setStyle() {
        contentView.backgroundColor = .grayGray10
        containerView.backgroundColor = .white
        
        nicknameLabel.do {
            $0.font = .pretendardB(20)
            $0.textColor = .grayBlack
            $0.text = "\(UserDefaults.nickname ?? "")님"
            $0.setTextStyle(targetStringList: ["님"], font: .pretendardM(20), color: .grayBlack)
        }
        
        editNicknameButton.do {
            $0.setTitle("닉네임 수정", for: .normal)
            $0.setTitleColor(.mainBlue4, for: .normal)
            $0.titleLabel?.font = .pretendardR(14)
            $0.setImage(FogImage.btnPen, for: .normal)
        }
    }
    
    override func setLayout() {
        contentView.addSubview(containerView)
        containerView.addSubviews([nicknameLabel, editNicknameButton])
        
        containerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(6)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18)
            $0.leading.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(29)
        }
        
        editNicknameButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalTo(nicknameLabel.snp.centerY)
        }
    }
}

// MARK: - Custom Methods
extension SettingNicknameTableViewCell {

    // 닉네임 수정 버튼 터치 이벤트 방출 메서드
    func editNicknameButtonDidTap() -> Signal<Void> {
        return editNicknameButton.rx.tap.asSignal()
    }
}
