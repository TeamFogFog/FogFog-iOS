//
//  ExternalMapModalView.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/25.
//

import UIKit

import RxCocoa
import RxSwift
import FlexLayout
import PinLayout

final class ExternalMapModalView: BaseView {
  
  // MARK: - UI
  
  private let rootFlexContainer: UIView = {
    let view = UIView()
    view.clipsToBounds = false
    view.backgroundColor = .black.withAlphaComponent(0.5)
    return view
  }()
  
  private let containerView: UIView = {
    let view = UIView()
    view.clipsToBounds = false
    view.backgroundColor = .white
    view.makeRounded(cornerRadius: 25)
    return view
  }()
  
  private let bubbleImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = FogImage.speechBubbleBig
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let popupIconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = FogImage.popupMap
    imageView.contentMode = .scaleAspectFit
    imageView.addShadow(
        offset: .init(width: 0, height: 5),
        color: .fogBlue,
        opacity: 0.3,
        radius: 10
    )
    return imageView
  }()
 
  fileprivate let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(FogImage.btnX, for: .normal)
    button.contentMode = .scaleAspectFit
    return button
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "연결할 지도 선택이 필요해요"
    label.textColor = .black
    label.font = .pretendardB(18)
    return label
  }()
  
  fileprivate let kakaoMapButton: FogButton = {
    let button = FogButton(style: .unselected)
    button.title = ExternalMapType.kakao.title
    button.makeRounded(cornerRadius: 12.adjusted)
    return button
  }()
  
  fileprivate let googleMapButton: FogButton = {
    let button = FogButton(style: .unselected)
    button.title = ExternalMapType.google.title
    button.makeRounded(cornerRadius: 12.adjusted)
    return button
  }()
  
  fileprivate let naverMapButton: FogButton = {
    let button = FogButton(style: .unselected)
    button.title = ExternalMapType.naver.title
    button.makeRounded(cornerRadius: 12.adjusted)
    return button
  }()
  
  fileprivate let confirmButton: FogButton = {
    let button = FogButton(style: .normal)
    button.title = "확인"
    return button
  }()
  
  // MARK: - Layout
  
  override func setLayout() {
    addSubview(rootFlexContainer)
    addSubview(bubbleImageView)
    addSubview(popupIconImageView)
    
    rootFlexContainer.flex
      .justifyContent(.center)
      .alignItems(.center)
      .define { flex in
        flex.addItem(containerView)
          .justifyContent(.start)
          .alignItems(.center)
          
          .define { flex in
            flex.addItem(closeButton).position(.absolute).start(16).top(16)
            flex.addItem(titleLabel).marginTop(59.adjustedH)
            
            flex.addItem()
              .define { flex in
                flex.addItem(kakaoMapButton).height(54.adjustedH).marginTop(29.adjustedH)
                flex.addItem(googleMapButton).height(54.adjustedH).marginTop(8.adjustedH)
                flex.addItem(naverMapButton).height(54.adjustedH).marginTop(8.adjustedH)
              }
              .width(100%)
              .paddingHorizontal(13.adjusted)
            
            flex.addItem().grow(1)
            flex.addItem(confirmButton).width(100%).height(65.adjustedH)
          }
          .width(343.adjusted)
          .height(375.adjustedH)
      }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    rootFlexContainer.pin.all()
    rootFlexContainer.flex.layout()
    
    popupIconImageView.pin.center(to: containerView.anchor.topCenter).size(78.adjustedH)
    bubbleImageView.pin.bottomCenter(to: popupIconImageView.anchor.topCenter).width(217.adjusted).height(57.adjustedH).marginBottom(7.adjustedH)
  }
}

// MARK: - Reactive Extension

extension Reactive where Base: ExternalMapModalView {
  var closeButtonDidTap: ControlEvent<Void> {
    return base.closeButton.rx.tap
  }
  
  var kakaoMapButtonDidTap: ControlEvent<Void> {
    return base.kakaoMapButton.button.rx.tap
  }
  
  var googleMapButtonDidTap: ControlEvent<Void> {
    return base.googleMapButton.button.rx.tap
  }
  
  var naverMapButtonDidTap: ControlEvent<Void> {
    return base.naverMapButton.button.rx.tap
  }
  
  var confirmButtonDidTap: ControlEvent<Void> {
    return base.confirmButton.button.rx.tap
  }
  
  var updateViews: Binder<ExternalMapType> {
    return Binder(base) { base, externalMapType in
      switch externalMapType {
      case .kakao:
        base.kakaoMapButton.style = .selected
        base.googleMapButton.style = .unselected
        base.naverMapButton.style = .unselected
      case .google:
        base.kakaoMapButton.style = .unselected
        base.googleMapButton.style = .selected
        base.naverMapButton.style = .unselected
      case .naver:
        base.kakaoMapButton.style = .unselected
        base.googleMapButton.style = .unselected
        base.naverMapButton.style = .selected
      }
    }
  }
}

// MARK: - Preview

#if DEBUG
import SwiftUI

struct ViewPreviewProvider: UIViewRepresentable {
  let view: UIView
  
  init(_ builder: () -> UIView) {
    self.view = builder()
  }
  
  func makeUIView(context: Context) -> some UIView {
    return view
  }
  
  func updateUIView(_ view: UIViewType, context: Context) {
    view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    view.setContentHuggingPriority(.defaultHigh, for: .vertical)
  }
}

struct View_Previews: PreviewProvider {
  static var previews: some View {
    ViewPreviewProvider {
      ExternalMapModalView()
    }
    .previewLayout(.sizeThatFits)
  }
}
#endif
