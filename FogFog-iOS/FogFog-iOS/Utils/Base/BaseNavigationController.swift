//
//  BaseNavigationController.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/10/22.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    private(set) var isTransitioning: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.isHidden = true
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
        
        // 특정 뷰 컨트롤러에 대해서 Popped 되는 것을 막고 싶다면, preventInteractivePopGesture 오버라이딩해서 false로 수정
        if let viewController = visibleViewController as? BaseViewController, viewController.preventInteractivePopGesture() {
            return false
        }
        
        return viewControllers.count > 1 && isTransitioning == false
    }
}

// MARK: - UINavigationControllerDelegate

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        isTransitioning = false
    }
}
