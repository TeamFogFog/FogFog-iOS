//
//  DefaultMapCoordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class DefaultMapCoordinator: MapCoordinator {
 
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .map }

    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showMapViewController()
    }

    func showMapViewController() {
        let mapViewModel = MapViewModel(coordinator: self)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        changeAnimation()
        navigationController.viewControllers = [mapViewController]
    }
    
    func connectSettingCoordinator() {
        let settingCoordinator = DefaultSettingCoordinator(self.navigationController)
        settingCoordinator.finishDelegate = self
        self.childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
    func finish() {
        finishDelegate?.didFinish(childCoordinator: self)
    }
}

// MARK: - CoordinatorFinishDelegate
extension DefaultMapCoordinator: CoordinatorFinishDelegate {
    
    func didFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0.type != childCoordinator.type }
        childCoordinator.navigationController.popToRootViewController(animated: true)
    }
}
