//
//  DefaultSettingCoordinator.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/01/14.
//

import UIKit

final class DefaultSettingCoordinator: SettingCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .setting }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showSettingViewController() {
        let settingViewModel = SettingViewModel(coordinator: self)
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        navigationController.pushViewController(settingViewController, animated: true)
    }
    
    // 닉네임 수정 뷰로 이동
    func connectLoginCoordinator() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        loginCoordinator.finishDelegate = self
        self.childCoordinators.append(loginCoordinator)
        loginCoordinator.showMakeNicknameViewController()
    }
    
    func start() {
        showSettingViewController()
    }
}

// MARK: - CoordinatorFinishDelegate
extension DefaultSettingCoordinator: CoordinatorFinishDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
