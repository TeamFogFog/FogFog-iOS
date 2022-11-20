//
//  SignInViewController.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/11/18.
//

import UIKit

import SnapKit
import Then

final class SignInViewController: BaseViewController {
    
    // MARK: Properties
    private let titleLabel = UILabel()
    private let firstCheckImageView = UIImageView()
    private let secondCheckImageView = UIImageView()
    private let firstSubtitleLabel = UILabel()
    private let secondSubtitleLabel = UILabel()
    private let mapImageView = UIImageView()
    private let speechBubbleImageView = UIImageView()
    private let speechBubbleLabel = UILabel()
    private let kakaoButton = UIButton()
    private let appleButton = UIButton()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setStyle()
        setLayout()
    }
    
    // MARK: UI
    override func setStyle() {
        
        view.setGradient(.fogBlue, .white)
        
        titleLabel.do {
            $0.text = "내 근처 흡연 구역은\n포그포그로 해결"
            $0.font = .pretendardB(30)
            $0.textAlignment = .left
            $0.textColor = .white
            $0.numberOfLines = 2
        }
        
        [firstCheckImageView, secondCheckImageView].forEach {
            $0.do { $0.image = FogImage.check }
        }
        
        firstSubtitleLabel.do {
            $0.text = "서울시 783개 흡연구역"
            $0.font = .pretendardM(16)
            $0.textAlignment = .left
            $0.textColor = .white
        }
        
        secondSubtitleLabel.do {
            $0.text = "지속적으로 업데이트 되는 데이터"
            $0.font = .pretendardM(16)
            $0.textAlignment = .left
            $0.textColor = .white
        }
        
        mapImageView.do {
            $0.image = FogImage.mapImage
        }
        
        speechBubbleImageView.do {
            $0.image = FogImage.speechBubble
            $0.addShadow(offset: CGSize(width: 0, height: 2), color: .shadowGray, opacity: 0.14, radius: 17)
        }
        
        speechBubbleLabel.do {
            $0.text = "3초만에 포그포그 시작하기"
            $0.font = .pretendardM(14)
            $0.textAlignment = .center
            $0.textColor = .gray1
        }
        
        kakaoButton.do {
            $0.makeRounded(cornerRadius: 12.adjusted)
            $0.backgroundColor = .kakaoYellow
            $0.setTitle("카카오로 시작하기", for: .normal)
            $0.setTitleColor(.fogBlack, for: .normal)
            $0.titleLabel?.font = .pretendardB(16)
            $0.setImage(FogImage.kakaoLogo, for: .normal)
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 140)
        }
        
        appleButton.do {
            $0.makeRounded(cornerRadius: 12.adjusted)
            $0.backgroundColor = .fogBlack
            $0.setTitle("Apple로 시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .pretendardB(16)
            $0.setImage(FogImage.appleLogo, for: .normal)
            $0.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 140)
        }
    }
    
    override func setLayout() {
        view.addSubviews([titleLabel, firstCheckImageView, secondCheckImageView,
                          firstSubtitleLabel, secondSubtitleLabel, mapImageView,
                          speechBubbleImageView, speechBubbleLabel, kakaoButton, appleButton])
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(94)
            $0.leading.equalToSuperview().inset(16)
        }
        
        firstCheckImageView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.size.equalTo(18)
        }
        
        secondCheckImageView.snp.makeConstraints {
            $0.top.equalTo(firstCheckImageView.snp.bottom).offset(12)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.size.equalTo(18)
        }
        
        firstSubtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(firstCheckImageView.snp.trailing).offset(11)
            $0.centerY.equalTo(firstCheckImageView.snp.centerY)
        }
        
        secondSubtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(secondCheckImageView.snp.trailing).offset(11)
            $0.centerY.equalTo(secondCheckImageView.snp.centerY)
        }
        
        mapImageView.snp.makeConstraints {
            $0.top.equalTo(secondSubtitleLabel.snp.bottom).offset(48.adjustedH)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(78.adjusted)
        }
        
        speechBubbleImageView.snp.makeConstraints {
            $0.top.equalTo(mapImageView.snp.bottom).offset(82.adjustedH)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(196)
            $0.height.equalTo(40)
        }
        
        speechBubbleLabel.snp.makeConstraints {
            $0.top.equalTo(speechBubbleImageView.snp.top).inset(9)
            $0.leading.equalTo(speechBubbleImageView.snp.leading).inset(20)
            $0.trailing.equalTo(speechBubbleImageView.snp.trailing).inset(20)
            $0.bottom.equalTo(speechBubbleImageView.snp.bottom).inset(16)
        }
        
        kakaoButton.snp.makeConstraints {
            $0.top.equalTo(speechBubbleImageView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(17)
            $0.height.equalTo(54)
        }
        
        appleButton.snp.makeConstraints {
            $0.top.equalTo(kakaoButton.snp.bottom).offset(8)
            $0.leading.equalTo(kakaoButton.snp.leading)
            $0.trailing.equalTo(kakaoButton.snp.trailing)
            $0.height.equalTo(54)
            $0.bottom.equalToSuperview().inset(70)
        }
    }
}
