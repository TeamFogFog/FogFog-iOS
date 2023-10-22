//
//  BaseNavigationController.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/10/22.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private(set) var isTransitioning: Bool = false
    
    /// Pop Gesture 막아야 하는 뷰 컨트롤러의 타입 배열
    private var disabledPopViewControllers: [AnyClass] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        isTransitioning = true
        
        super.pushViewController(viewController, animated: animated)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == interactivePopGestureRecognizer else {
            return true
        }
    
        return viewControllers.count > 1 && isTransitioning == false && isPopGestureEnabled()
    }
    
    private func isPopGestureEnabled() -> Bool {
        guard let topViewController else { return false }
        
        for viewController in disabledPopViewControllers where topViewController.isKind(of: viewController.self) {
            return false
        }
        return true
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isTransitioning = false
    }
}
