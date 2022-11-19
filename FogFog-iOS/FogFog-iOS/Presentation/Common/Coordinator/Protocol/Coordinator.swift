//
//  Coordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/16.
//

import UIKit

protocol Coordinator: AnyObject {

    var finishDelegate: CoordinatorFinishDelegate? { get set }
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    var type: CoordinatorCase { get }
    func start()
    func finish()

    init(_ navigationController: UINavigationController)
}

extension Coordinator {

    func finish() {
        
        childCoordinators.removeAll()
        finishDelegate?
            .didFinish(childCoordinator: self)
    }

    func changeAnimation() {
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        if let window = window {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionCrossDissolve,
                              animations: nil)
        }
    }
}

