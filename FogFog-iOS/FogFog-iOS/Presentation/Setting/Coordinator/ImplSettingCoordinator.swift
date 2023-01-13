//
//  ImplSettingCoordinator.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/01/14.
//

import UIKit

final class ImplSettingCoordinator: SettingCoordinator {
    
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
    
    func start() {
        showSettingViewController()
    }
}
