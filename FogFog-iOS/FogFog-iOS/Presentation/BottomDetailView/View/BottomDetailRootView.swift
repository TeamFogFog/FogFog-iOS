//
//  BottomDetailRootView.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/20.
//

import UIKit

final class BottomDetailRootView: BaseView {
    
    // MARK: Literals
    enum Literals {
        static let dummyDistance = "223m"
        static let dummyPlaceTitle = "흡연구역"
        static let dummyDetailAddress = "상세주소"
        static let findRouteButtonTitle = "길 찾기"
    }
    
    // MARK: Metrics
    enum Metrics {
        static let margin = 13.adjusted
        
        static let bottomSheetViewWidth = 343.adjusted
        static let bottomSheetViewHeight = 186.adjustedH
        static let bottomSheetBottom = 47.adjustedH
        
        static let imageContainerSize = 122.adjusted
        static let imageContainerTop = 18.adjustedH
        static let imageContainerLeading = 13.adjusted
        static let imageInsets = 2.adjusted
        
        static let distanceButtonSize = CGSize(width: 47.adjusted, height: 18.adjustedH)
        static let distanceButtonTop = 13.adjustedH
        static let distanceButtonLeading = 13.adjusted
        
        static let placeTitleTop = 7.adjustedH
        static let placeMarkerSize = 17.adjusted
        static let placeMarkerTop = 22.adjustedH
        static let detailLabelLeading = 2.adjusted
        
        static let findRouteButtonSize = CGSize(width: 317.adjusted, height: 54.adjustedH)
        static let findRouteButtonBottom = 14.adjustedH
    }
    
    // MARK: UI
    private let bottomSheetView = UIView()
    private let placeImageViewContainer = UIView()
    private let placeImageView = UIImageView()
    private let distanceButton = UIButton()
    private let placeTitleLabel = UILabel()
    private let placeMarkerImageView = UIImageView()
    private let placeDetailTitleLabel = UILabel()
    private let findRouteButton = UIButton()
    
    override func setStyle() {
        backgroundColor = .white
        
        bottomSheetView.do {
            $0.clipsToBounds = false
            $0.backgroundColor = .white
            $0.makeRounded(cornerRadius: 20)
            $0.addShadow(offset: .zero, color: .black, opacity: 0.15, radius: 20)
        }
        
        placeImageViewContainer.do {
            $0.backgroundColor = .white
            $0.makeRounded(cornerRadius: 15)
            $0.addShadow(offset: CGSize(width: 0, height: 3), color: .black, opacity: 0.14, radius: 9)
        }
        
        placeImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .fogBlue
            $0.makeRounded(cornerRadius: 15)
        }
        
        distanceButton.do {
            $0.setTitle(Literals.dummyDistance, for: .normal)
            $0.setTitleColor(.fogBlue, for: .normal)
            $0.titleLabel?.font = .pretendardM(12)
            $0.backgroundColor = .blue8
            $0.makeRounded(cornerRadius: 6)
        }
        
        placeTitleLabel.do {
            $0.text = Literals.dummyPlaceTitle
            $0.font = .pretendardB(18)
        }
        
        placeMarkerImageView.do {
            $0.image = FogImage.placeMarker
        }
        
        placeDetailTitleLabel.do {
            $0.text = Literals.dummyDetailAddress
            $0.textColor = .gray6
            $0.font = .pretendardR(14)
        }

        findRouteButton.do {
            $0.titleLabel?.font = .pretendardB(18)
            $0.setTitle(Literals.findRouteButtonTitle, for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.backgroundColor = .black
            $0.makeRounded(cornerRadius: 12)
        }
    }
    
    override func setLayout() {
        self.addSubview(bottomSheetView)
        placeImageViewContainer.addSubview(placeImageView)
        bottomSheetView.addSubviews([
            placeImageViewContainer,
            distanceButton,
            placeTitleLabel,
            placeMarkerImageView,
            placeDetailTitleLabel,
            findRouteButton
        ])
        
        bottomSheetView.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(Metrics.margin)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(Metrics.bottomSheetBottom)
            $0.height.equalTo(Metrics.bottomSheetViewHeight)
        }
        
        placeImageViewContainer.snp.makeConstraints {
            $0.top.equalTo(bottomSheetView.snp.top).offset(-Metrics.imageContainerTop)
            $0.leading.equalTo(bottomSheetView.snp.leading).offset(Metrics.imageContainerLeading)
            $0.size.equalTo(Metrics.imageContainerSize)
        }
        
        placeImageView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Metrics.imageInsets)
        }
        
        distanceButton.snp.makeConstraints {
            $0.size.equalTo(Metrics.distanceButtonSize)
            $0.top.equalToSuperview().offset(Metrics.distanceButtonTop)
            $0.leading.equalTo(placeImageViewContainer.snp.trailing).offset(Metrics.distanceButtonLeading)
        }
        
        placeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(distanceButton.snp.bottom).offset(Metrics.placeTitleTop)
            $0.leading.equalTo(distanceButton.snp.leading)
            $0.trailing.equalToSuperview().inset(Metrics.margin)
        }
        
        placeMarkerImageView.snp.makeConstraints {
            $0.size.equalTo(Metrics.placeMarkerSize)
            $0.leading.equalTo(distanceButton.snp.leading)
            $0.top.equalTo(placeTitleLabel.snp.bottom).offset(Metrics.placeMarkerTop)
        }
        
        placeDetailTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(placeMarkerImageView.snp.trailing).offset(Metrics.detailLabelLeading)
            $0.trailing.equalToSuperview().inset(Metrics.margin)
            $0.bottom.equalTo(placeMarkerImageView.snp.bottom)
        }
        
        findRouteButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Metrics.findRouteButtonSize)
            $0.bottom.equalToSuperview().inset(Metrics.findRouteButtonBottom)
        }
    }
}
