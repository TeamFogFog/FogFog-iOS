//
//  FogToast.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/12/03.
//

import UIKit

import SnapKit
import Then

final class FogToast: BaseView {
    
    // MARK: Properties
    private var style = FogToastStyle.default
    private let padding: CGFloat = 16

    // MARK: UI
    private let titleLabel = UILabel()
    
    init(style: FogToastStyle = FogToastStyle.default) {
        super.init(frame: .zero)
        self.style = style
        print("FogToast init")
    }
    
    deinit {
        print("FogToast Deinit")
    }

    override func setStyle() {
        backgroundColor = style.backgroundColor
        makeRounded(cornerRadius: style.cornerRadius)
        alpha = style.alpha
        
        titleLabel.do {
            $0.textColor = style.textColor
            $0.textAlignment = .center
            $0.font = .pretendardM(14)
        }
    }
    
    override func setLayout() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.directionalHorizontalEdges.equalToSuperview().inset(padding)
            $0.centerY.equalToSuperview()
        }
    }
}

extension FogToast {

    /// 토스트 띄워주는 메서드
    ///
    /// - Paramters:
    ///     - on: 토스트를 띄울 ViewController입니다.
    ///     - completion: 토스트를 띄운 후 실행할 클로저입니다.
    func present(
        on viewController: UIViewController,
        completion: @escaping (() -> Void) = {}
    ) {
        let size = CGSize(width: style.width, height: style.height)
        
        viewController.view.addSubview(self)
        self.snp.makeConstraints {
            $0.height.equalTo(size.height)
            $0.width.equalTo(size.width)
            $0.centerX.equalTo(viewController.view)
        }

        DispatchQueue.main.async { [unowned self] in
            switch self.style.position {
            case .topToBottom:
                self.snp.makeConstraints {
                    $0.top.equalTo(viewController.view.safeAreaLayoutGuide).offset(-size.height * 2)
                }
                
                DispatchQueue.main.async {
                    self.snp.updateConstraints {
                        $0.top.equalTo(viewController.view.safeAreaLayoutGuide).inset(16)
                    }
                    
                    UIView.animate(withDuration: 0.5) {
                        viewController.view.layoutIfNeeded()
                    } completion: { _ in
                        completion()
                    }
                }
                
            case .bottomToTop:
                self.snp.makeConstraints {
                    $0.bottom.equalTo(viewController.view.safeAreaLayoutGuide).offset(size.height * 2)
                }
                
                DispatchQueue.main.async {
                    self.snp.updateConstraints {
                        $0.bottom.equalTo(viewController.view.safeAreaLayoutGuide).inset(16)
                    }
                    
                    UIView.animate(withDuration: 0.5) {
                        viewController.view.layoutIfNeeded()
                    } completion: { _ in
                        completion()
                    }
                }
            }
            
            if !self.style.isMaintained {
                self.dismiss()
            }
        }
    }

    /// 토스트 해제 메서드
    ///
    /// - Paramters:
    ///     - deadline: 유지시킬 시간을 설정합니다. 기본값은 2(초)입니다.
    ///     - completion: 토스트를 해제하고 실행할 클로저입니다.
    func dismiss(
        _ deadline: CGFloat = 2.0,
        completion: @escaping (() -> Void) = {}
    ) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + deadline,
            execute: {
                UIView.animate(withDuration: 0.5) {
                    self.alpha = 0.0
                } completion: { _ in
                    self.removeFromSuperview()
                }
            })
        
        completion()
    }
}

// MARK: Configure Style
extension FogToast {
    
    /// 사이즈 정해주는 메서드
    /// Note. 너비와 높이가 동일할 때 해당 메서드를 사용합니다.
    /// Note. 정해주지 않으면 기본 사이즈가 지정됩니다.
    ///
    /// - Paramters:
    ///     - side: 너비 및 높이
    func setSize(_ side: CGFloat) -> FogToast {
        style.width = side
        style.height = side
        return self
    }
    
    /// 사이즈 정해주는 메서드
    /// Note. 너비와 높이가 다를 때 해당 메서드를 사용합니다.
    /// Note. 정해주지 않으면 기본 사이즈가 지정됩니다.
    ///
    /// - Paramters:
    ///     - width: 너비
    ///     - height: 높이
    func setSize(w width: CGFloat, h height: CGFloat) -> FogToast {
        style.width = width
        style.height = height
        return self
    }
    
    /// ✨ 토스트 안에 들어갈 내용 정해주는 메서드
    ///
    /// - Paramters:
    ///     - text: 내용(텍스트)
    func setContents(_ text: String) -> FogToast {
        titleLabel.text = text
        return self
    }
    
    /// 텍스트색 정해주는 메서드
    ///
    /// - Paramters:
    ///     - color: 텍스트 컬러
    func setTextColor(_ color: UIColor) -> FogToast {
        style.textColor = color
        return self
    }
    
    /// 토스트 배경색 정해주는 메서드
    ///
    /// - Paramters:
    ///     - color: 배경색
    func setBackgroundColor(_ color: UIColor) -> FogToast {
        backgroundColor = color
        return self
    }
    
    /// 토스트 알파값 정해주는 메서드
    ///
    /// - Paramters:
    ///     - alpha: 알파값
    func setAlpha(_ alpha: CGFloat) -> FogToast {
        style.alpha = alpha
        return self
    }
    
    /// 토스트를 띄운 후 유지여부를 결정하는 메서드
    /// Note. 정해주지 않으면 토스트는 제거되지 않습니다.
    ///
    /// - Paramters:
    ///     - isMaintained: 유지 여부 (기본값은 true입니다.)
    func maintain(_ isMaintained: Bool) -> FogToast {
        style.isMaintained = isMaintained
        return self
    }
    
    /// 토스트 표시 방향을 결정하는 메서드
    /// Note. topToBottom, bottomToTop 2가지 상태가 있습니다.
    /// Note. 정해주지 않으면 토스트가 bottomToTop(아래에서 위로) 나타납니다.
    ///
    /// - Paramters:
    ///     - position: 토스트 표시 방향 (기본값은 bottomToTop입니다.)
    func setPosition(_ position: FogToast.FogToastStyle.Position = .bottomToTop) -> FogToast {
        style.position = position
        return self
    }
}

// MARK: Style
extension FogToast {
    
    struct FogToastStyle {
        
        // Position
        enum Position {
            case topToBottom, bottomToTop
        }
        
        // Animation
        var isMaintained: Bool = true
        var position: Position = .bottomToTop
        var duration: CGFloat?
        
        // Color
        var textColor: UIColor
        var backgroundColor: UIColor
        var alpha: CGFloat = 0.7
        
        // Layer
        var cornerRadius: CGFloat
        
        // Size
        var width: CGFloat = 254
        var height: CGFloat = 46
        
        // Default Style
        static var `default` = FogToastStyle(
            duration: 0.15,
            textColor: .grayWhite,
            backgroundColor: .grayGray1,
            cornerRadius: 10
        )
    }
}
