//
//  Presentable.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/04/20.
//

import UIKit

/// 해당 프로토콜은 BottomViewController에서 사용된다.
/// 하단에서 올라오는 뷰에 채택한 뒤 사용한다.
protocol Presentable {
    func viewHeight() -> CGFloat
    func bind(_ content: Contents)    // 데이터 바인딩
    func show(withMovement: CGFloat, withDuration: CGFloat) // 위로 올리는 메소드
}

extension Presentable where Self: UIView {
    
    func show(withMovement: CGFloat, withDuration: CGFloat) {
        self.snp.updateConstraints {
            $0.bottom.equalToSuperview().inset(withMovement)
        }

        guard let superview else { fatalError("Has not superview") }
        UIView.animate(withDuration: withDuration, animations: superview.layoutIfNeeded)
    }
}
