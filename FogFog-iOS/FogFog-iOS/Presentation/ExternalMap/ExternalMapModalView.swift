//
//  ExternalMapModalView.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import UIKit

final class ExternalMapModalView: BaseView {
    
    // MARK: UI
    let dimmedView = UIView()
    let containerView = UIView()
    let closeButton = UIButton()
    let bubbleImageView = UIImageView()
    let popupIconImageView = UIImageView()
    let titleLabel = UILabel()
    let buttonStack = UIStackView()
    let lineView = UIView()
    let confirmButton = FogButton(style: .normal)
    
    // MARK: Properties
    private let padding: CGFloat = 20
    private let containerRadius: CGFloat = 25
    private let buttonRadius: CGFloat = 12
    
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setStackView()
    }
    
    // MARK: Setup UI
    override func setStyle() {
        super.setStyle()
        
        backgroundColor = .systemBackground
        
        dimmedView.do {
            $0.backgroundColor = .grayGray2
            $0.alpha = 0.65
        }

        containerView.do {
            $0.backgroundColor = .white
            $0.makeRounded(cornerRadius: containerRadius)
        }
        
        closeButton.do {
            $0.setImage(FogImage.btnX, for: .normal)
        }
        
        popupIconImageView.do {
            $0.image = FogImage.popupMap
            $0.addShadow(
                offset: .init(width: 0, height: 5),
                color: .fogBlue,
                opacity: 0.3,
                radius: 10
            )
        }
        
        bubbleImageView.do {
            $0.image = FogImage.speechBubbleBig
        }
        
        titleLabel.do {
            $0.text = "연결할 지도 선택이 필요해요"
            $0.textColor = .black
            $0.font = .pretendardB(18)
        }
        
        buttonStack.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
        }
        
        lineView.do {
            $0.backgroundColor = .grayGray9
        }
        
        confirmButton.do {
            $0.title = "확인"
            $0.makeRounded(cornerRadius: buttonRadius)
        }
        
        buttonStack.do {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 8
        }
    }
    
    override func setLayout() {
        addSubviews([dimmedView, containerView])
        addSubviews([closeButton, popupIconImageView, bubbleImageView])
        addSubviews([titleLabel, buttonStack, lineView, confirmButton])
        
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(padding)
            $0.height.greaterThanOrEqualTo(380)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.leading.equalTo(containerView).inset(15)
        }
        
        popupIconImageView.snp.makeConstraints {
            $0.centerX.equalTo(containerView)
            $0.centerY.equalTo(containerView.snp.top)
            $0.size.equalTo(78)
        }
        
        bubbleImageView.snp.makeConstraints {
            $0.centerX.equalTo(popupIconImageView)
            $0.bottom.equalTo(popupIconImageView.snp.top).offset(-6)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(popupIconImageView.snp.bottom).offset(24)
            $0.centerX.equalTo(containerView)
        }
        
        confirmButton.snp.makeConstraints {
            $0.bottom.equalTo(containerView.snp.bottom).inset(13)
            $0.directionalHorizontalEdges.equalTo(containerView).inset(12)
            $0.height.equalTo(54)
        }
        
        lineView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalTo(containerView)
            $0.height.equalTo(1)
            $0.bottom.equalTo(confirmButton.snp.top).offset(-12.5)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(28)
            $0.directionalHorizontalEdges.equalTo(containerView).inset(12)
            $0.bottom.equalTo(lineView.snp.top).offset(-12.5)
        }
    }
}

// MARK: Private Methods
extension ExternalMapModalView {
    
    private func setStackView() {
        ExternalMapType.allCases.forEach { type in
            let button = FogButton(style: .unselected)
            button.title = type.title
            button.makeRounded(cornerRadius: buttonRadius.adjusted)
            buttonStack.addArrangedSubview(button)
        }
    }
}

// MARK: Public Methods
extension ExternalMapModalView {

    func select(to type: ExternalMapType) {
        for (index, button) in buttonStack.arrangedSubviews.enumerated() {
            guard let button = button as? FogButton else { return }
            button.style = index == type.rawValue ? .selected : .unselected
        }
    }
}
