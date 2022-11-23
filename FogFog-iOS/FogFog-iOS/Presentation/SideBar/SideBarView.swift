//
//  SideBarView.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/22.
//

import UIKit

import SnapKit
import Then

final class SideBarView: UIView {
    
    // MARK: Properties
    private let blueView = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let settingButton = UIButton()
    private let mapSettingContainerView = UIView()
    private let mapLogoImageView = UIImageView()
    private let mapSettingTitleLabel = UILabel()
    private let mapSettingSubtitleLabel = UILabel()
    private let reportContainerView = UIView()
    private let reportLogoImageView = UIImageView()
    private let reportTitleLabel = UILabel()
    private let reportSubtitleLabel = UILabel()
    private let lineView = UIView()
    private let noticeButton = UIButton()
    private let questionButton = UIButton()
    private let versionLabel = UILabel()
    private let updateButton = UIButton()
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setStyle()
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UI
    private func setStyle() {
        
        self.backgroundColor = .white
        
        blueView.do {
            $0.backgroundColor = .fogBlue
        }
        
        logoImageView.do {
            $0.image = FogImage.logo
        }
        
        titleLabel.do {
            $0.text = "더 나은 흡연 문화를 위한 한걸음"
            $0.font = .pretendardM(16)
            $0.textColor = .white
            $0.textAlignment = .left
        }
        
        nicknameLabel.do {
            $0.text = "유지인님"
            $0.font = .pretendardB(20)
            $0.textColor = .grayBlack
            $0.textAlignment = .left
        }
        
        settingButton.do {
            $0.setImage(FogImage.btnSet, for: .normal)
        }
        
        mapLogoImageView.do {
            $0.image = FogImage.btnMap
        }
        
        mapSettingTitleLabel.do {
            $0.text = "연결할 지도 설정"
            $0.font = .pretendardM(16)
            $0.textColor = .grayBlack
        }
        
        mapSettingSubtitleLabel.do {
            $0.text = "자주 사용하는 지도를 바꿔보세요"
            $0.font = .pretendardM(12)
            $0.textColor = .grayGray7
        }
        
        reportLogoImageView.do {
            $0.image = FogImage.btnNotice
        }
        
        reportTitleLabel.do {
            $0.text = "흡연구역 제보 / 신고"
            $0.font = .pretendardM(16)
            $0.textColor = .grayBlack
        }
        
        reportSubtitleLabel.do {
            $0.text = "흡연 구역을 찾는 사람들에게 도움이 돼요"
            $0.font = .pretendardM(12)
            $0.textColor = .grayGray7
        }
        
        lineView.do {
            $0.backgroundColor = .grayGray10
        }
        
        noticeButton.do {
            $0.setTitle("공지사항", for: .normal)
            $0.setTitleColor(.grayGray3, for: .normal)
            $0.titleLabel?.font = .pretendardM(14)
        }
        
        questionButton.do {
            $0.setTitle("문의하기", for: .normal)
            $0.setTitleColor(.grayGray3, for: .normal)
            $0.titleLabel?.font = .pretendardM(14)
        }
        
        versionLabel.do {
            $0.text = "Ver 1.0.0"
            $0.font = .pretendardR(12)
            $0.textColor = .grayGray3
        }
        
        updateButton.do {
            $0.setTitle("최신버전", for: .normal)
            $0.titleLabel?.font = .pretendardR(12)
            $0.setTitleColor(.fogBlue, for: .normal)
        }
    }
    
    private func setLayout() {
        
        self.addSubviews([blueView, nicknameLabel, settingButton,
                          mapSettingContainerView, reportContainerView, lineView,
                          noticeButton, questionButton, versionLabel, updateButton])
        blueView.addSubviews([logoImageView, titleLabel])
        mapSettingContainerView.addSubviews([mapLogoImageView, mapSettingTitleLabel, mapSettingSubtitleLabel])
        reportContainerView.addSubviews([reportLogoImageView, reportTitleLabel, reportSubtitleLabel])
        
        blueView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(164)
        }
        
        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(77)
            $0.leading.equalToSuperview().inset(15)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(14)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(blueView.snp.bottom).offset(44)
            $0.leading.equalToSuperview().inset(16)
        }
        
        settingButton.snp.makeConstraints {
            $0.trailing.equalTo(blueView.snp.trailing).inset(15)
            $0.size.equalTo(22)
            $0.centerY.equalTo(nicknameLabel.snp.centerY)
        }
        
        mapSettingContainerView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(43)
            $0.leading.equalToSuperview().inset(13)
            $0.width.equalTo(160)
        }
        
        mapLogoImageView.snp.makeConstraints {
            $0.centerY.equalTo(mapSettingTitleLabel.snp.centerY)
            $0.size.equalTo(18)
        }
        
        mapSettingTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(mapLogoImageView.snp.trailing).offset(2)
        }
        
        mapSettingSubtitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(2)
            $0.top.equalTo(mapLogoImageView.snp.bottom).offset(7)
            $0.bottom.equalToSuperview()
        }
        
        reportContainerView.snp.makeConstraints {
            $0.top.equalTo(mapSettingContainerView.snp.bottom).offset(25)
            $0.leading.equalToSuperview().inset(14)
            $0.width.equalTo(192)
        }
        
        reportLogoImageView.snp.makeConstraints {
            $0.centerY.equalTo(reportTitleLabel.snp.centerY)
            $0.size.equalTo(18)
        }
        
        reportTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(reportLogoImageView.snp.trailing).offset(1)
        }
        
        reportSubtitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(1)
            $0.top.equalTo(reportLogoImageView.snp.bottom).offset(7)
            $0.bottom.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(reportContainerView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(1)
        }
        
        noticeButton.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().inset(16)
            $0.height.equalTo(14)
        }
        
        questionButton.snp.makeConstraints {
            $0.top.equalTo(noticeButton.snp.bottom).offset(25)
            $0.leading.equalTo(noticeButton.snp.leading)
            $0.height.equalTo(14)
        }
        
        versionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(39)
        }
        
        updateButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalTo(versionLabel.snp.centerY)
            $0.height.equalTo(12)
            $0.width.equalTo(45)
        }
    }
}
