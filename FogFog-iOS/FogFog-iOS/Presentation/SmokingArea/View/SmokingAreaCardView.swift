//
//  SmokingAreaCardView.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/04/20.
//

import UIKit

import SnapKit
import Then

final class SmokingAreaCardView: BaseView, Presentable {
    
    private enum Metrics {
        static var screenHeight: CGFloat {
            return UIScreen.main.bounds.height
        }
        static let bottomSheetViewWidth = 343.adjusted
        static var bottomSheetViewHeight: CGFloat {
            return screenHeight <= 667.0 ? 186.0 : 186.0.adjustedH
        }
        static let bottomSheetUp = 47.adjustedH
    }
    
    // MARK: UI
    private let containerView = UIView()
    
    private let imageBackgroundView = UIView()
    private let imageView = UIImageView()
    private let distanceButton = UIButton()
    private let titleLabel = UILabel()
    private let locationMarkerImageView = UIImageView()
    private let locationButton = UIButton()
    private let reportButton = UIButton()
    private let findRouteButton = UIButton()
    private let moveLocationButton = UIButton()
    
    override func setStyle() {
        super.setStyle()
        
        backgroundColor = .white
        
        containerView.do {
            $0.clipsToBounds = false
            $0.backgroundColor = .white
            $0.makeRounded(cornerRadius: 20)
            $0.addShadow(offset: .zero, color: .black, opacity: 0.15, radius: 20)
        }
        
        imageBackgroundView.do {
            $0.backgroundColor = .white
            $0.makeRounded(cornerRadius: 15)
            $0.addShadow(offset: CGSize(width: 0, height: 3), color: .black, opacity: 0.14, radius: 9)
        }
        
        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .fogBlue
            $0.makeRounded(cornerRadius: 15)
        }
        
        distanceButton.do {
            $0.setTitleColor(.fogBlue, for: .normal)
            $0.titleLabel?.font = .pretendardM(12)
            $0.backgroundColor = .mainBlue8
            $0.makeRounded(cornerRadius: 6)
        }
        
        titleLabel.do {
            $0.textColor = .black
            $0.font = .pretendardB(18)
        }
        
        locationMarkerImageView.do {
            $0.image = FogImage.placeMarker
        }
        
        locationButton.do {
            $0.setTitleColor(.grayGray6, for: .normal)
            $0.contentHorizontalAlignment = .left
            $0.titleLabel?.font = .pretendardR(14)
        }
        
        reportButton.do {
            $0.setImage(FogImage.siren, for: .normal)
        }

        findRouteButton.do {
            $0.titleLabel?.font = .pretendardB(18)
            $0.setTitle("길 찾기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black
            $0.makeRounded(cornerRadius: 12)
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
            $0.directionalHorizontalEdges.equalToSuperview().inset(13.adjusted)
            $0.bottom.equalToSuperview().inset(-Metrics.bottomSheetViewHeight)
            $0.height.equalTo(Metrics.bottomSheetViewHeight)
        }
        
        containerView.addSubviews([
            imageBackgroundView,
            distanceButton,
            titleLabel,
            locationMarkerImageView,
            locationButton,
            reportButton,
            findRouteButton,
            moveLocationButton
        ])
        
        // 이미지
        imageBackgroundView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13.adjusted)
            $0.size.equalTo(122.adjustedH)
            $0.top.equalToSuperview().inset(-16.adjustedH)
        }
        
        imageBackgroundView.addSubview(imageView)
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(2)
        }
        
        // 거리
        distanceButton.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 47.adjusted, height: 18.adjustedH))
            $0.top.equalToSuperview().inset(13.adjustedH)
            $0.leading.equalTo(imageBackgroundView.snp.trailing).offset(13.adjusted)
        }
        
        // 타이틀
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(distanceButton.snp.bottom).offset(7.adjustedH)
            $0.leading.equalTo(distanceButton.snp.leading)
            $0.trailing.equalToSuperview().inset(13.adjusted)
        }
        
        // 상세주소
        locationMarkerImageView.snp.makeConstraints {
            $0.leading.equalTo(distanceButton.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(26.adjustedH)
            $0.size.equalTo(17.adjustedH)
        }
        
        locationButton.snp.makeConstraints {
            $0.leading.equalTo(locationMarkerImageView.snp.trailing).offset(3.adjusted)
            $0.trailing.equalToSuperview().inset(13.adjusted)
            $0.centerY.equalTo(locationMarkerImageView.snp.centerY)
        }
        
        reportButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13.adjusted)
            $0.size.equalTo(20.adjustedH)
            $0.centerY.equalTo(distanceButton.snp.centerY)
        }
        
        // 길 찾기 버튼
        findRouteButton.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(13.adjusted)
            $0.bottom.equalToSuperview().inset(14.adjustedH)
            $0.height.equalTo(54.adjustedH)
        }
        
        moveLocationButton.snp.makeConstraints {
            $0.size.equalTo(62.adjustedH)
            $0.leading.equalTo(containerView.snp.leading).offset(-8.adjusted)
            $0.bottom.equalTo(imageBackgroundView.snp.top).offset(-31.adjustedH)
        }
    }
    
    func bind(_ content: Contents) {
        guard let content = content as? SmokingAreaResponseModel else { return }
        
        distanceButton.setTitle(content.distance, for: .normal)
        titleLabel.text = content.name
        locationButton.setTitle(content.address, for: .normal)
    }
    
    func viewHeight() -> CGFloat {
        return containerView.bounds.height
    }
}
