//
//  SmokingAreaMessageView.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/04/20.
//

import UIKit

import SnapKit
import Then

final class SmokingAreaMessageView: BaseView, Presentable {
    
    // MARK: UI
    
    private let containerView = UIView()
    private let messageLabel = UILabel()
    private let moveLocationButton = UIButton()
    
    override func setStyle() {
        super.setStyle()
        
        containerView.do {
            $0.clipsToBounds = false
            $0.backgroundColor = .grayGray1
            $0.alpha = 0.5
            $0.makeRounded(cornerRadius: 10.adjustedH)
        }
        
        messageLabel.do {
            $0.textColor = .grayWhite
            $0.textAlignment = .center
            $0.font = .pretendardM(14)
        }
        
        moveLocationButton.do {
            $0.setImage(FogImage.locationInactive, for: .normal)
            $0.contentMode = .scaleAspectFill
        }
    }
    
    override func setLayout() {
        super.setLayout()
        
        addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(254.adjusted)
            $0.height.equalTo(46.adjustedH)
            $0.bottom.equalTo(47.adjustedH)
        }

        containerView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(13.adjusted)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(moveLocationButton)
        moveLocationButton.snp.makeConstraints {
            $0.size.equalTo(62.adjustedH)
            $0.leading.equalToSuperview().offset(-4.adjusted)
            $0.bottom.equalTo(containerView.snp.top).offset(-38.adjustedH)
        }
    }

    func bind(_ content: Contents) {
        guard let content = content as? MessageModel else { return }
        messageLabel.text = content.contents
    }
    
    func viewHeight() -> CGFloat {
        return containerView.bounds.height
    }
}
