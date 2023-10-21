//
//  DefaultSettingCoordinator.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/01/14.
//

import UIKit

final class DefaultSettingCoordinator: NSObject, SettingCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .setting }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.interactivePopGestureRecognizer?.delegate = self
    }
    
    func start() {
        showSettingViewController()
    }
    
    func finish() {
        finishDelegate?
            .didFinish(childCoordinator: self)
    }
    
    func showSettingViewController() {
        let settingViewModel = SettingViewModel(coordinator: self)
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        navigationController.pushViewController(settingViewController, animated: true)
    }
    
    // 닉네임 수정 뷰로 이동
    func showEditNicknameViewController() {
        let editNicknameViewModel = MakeNicknameViewModel(coordinator: self)
        let editNicknameViewController = MakeNicknameViewController(viewModel: editNicknameViewModel)
        navigationController.pushViewController(editNicknameViewController, animated: true)
        editNicknameViewController.setNaviTitle(.edit)
    }
}

// MARK: - CoordinatorFinishDelegate
extension DefaultSettingCoordinator: CoordinatorFinishDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DefaultSettingCoordinator: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
