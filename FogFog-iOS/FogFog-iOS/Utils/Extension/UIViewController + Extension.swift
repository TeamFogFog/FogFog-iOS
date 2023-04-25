//
//  UIViewController + Extension.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2022/12/22.
//

import UIKit.UIViewController

extension UIViewController {
    
    static var className: String {
        NSStringFromClass(self.classForCoder()).components(separatedBy: ".").last!
    }
    
    var className: String {
        NSStringFromClass(self.classForCoder).components(separatedBy: ".").last!
    }
}

extension UIViewController {

    /// Bottom Presentable View 추가
    func addBottomView(_ subview: UIView, belowSubview: UIView? = nil) {
        // 기존에 깔려있는 하위 뷰 제거
        hideBottomView()

        // 특정 하위 뷰 아래에 추가 또는 가장 하위 뷰로 추가
        if let belowSubview = belowSubview {
            view.insertSubview(subview, belowSubview: belowSubview)
        } else {
            view.addSubview(subview)
        }
        
        // 레이아웃 초기화
        let defaultBottomMargin = 20
        let sideMargin = 13.adjusted
        subview.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(defaultBottomMargin)
            $0.directionalHorizontalEdges.equalToSuperview().inset(sideMargin)
        }
    }
    
    func hideBottomView() {
        // 기존에 깔려있는 BottomView hide animation 및 제거
        if let bottomView = view.subviews.first(where: { return ($0 is Presentable) }) {
            bottomView.snp.updateConstraints {
                $0.bottom.equalToSuperview().offset(20)
            }

            UIView.animate(withDuration: 0.3, animations: view.layoutIfNeeded) { _ in
                bottomView.removeFromSuperview()
            }
        }
    }

    // 흡연 구역 카드 뷰 보여주기 메소드
    func showCardView(
        _ content: Contents,
        belowSubview: UIView? = nil,
        withDuration: TimeInterval = 0.5
    ) {
        let cardView = SmokingAreaCardView()
        cardView.bind(content)
        addBottomView(cardView, belowSubview: belowSubview)

        let bottomMargin = 49.adjustedH
        DispatchQueue.main.async {
            cardView.show(withMovement: cardView.viewHeight() + bottomMargin, withDuration: withDuration)
        }
    }
    
    // 흡연 구역 메시지 뷰(= 토스트 뷰) 보여주기 메소드
    func showMessageView(
        _ content: Contents,
        belowSubview: UIView? = nil,
        withDuration: TimeInterval = 0.5
    ) {
        let messageView = SmokingAreaMessageView()
        messageView.bind(content)
        addBottomView(messageView, belowSubview: belowSubview)

        let bottomMargin = 49.adjustedH
        DispatchQueue.main.async {
            messageView.show(withMovement: messageView.viewHeight() + bottomMargin, withDuration: withDuration)
        }
    }
}
