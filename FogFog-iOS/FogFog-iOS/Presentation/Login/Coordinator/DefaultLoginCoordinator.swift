//
//  DefaultLoginCoordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class DefaultLoginCoordinator: LoginCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .login }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showLoginViewController()
    }
    
    func showLoginViewController() {
        let coordinator = DefaultLoginCoordinator(navigationController)
        let kakao = KakaoOAuthService()
        let oAuthService = OAuthService(oAuthService: kakao)
        let dependency = LoginViewModel.Dependency(coordinator: coordinator, oAuthService: oAuthService)
        let viewModel = LoginViewModel(dependency: dependency)
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func connectMapCoordinator() {
        let mapCoordinator = DefaultMapCoordinator(self.navigationController)
        mapCoordinator.start()
        self.childCoordinators.append(mapCoordinator)
    }
    
    func finish() {
        finishDelegate?.didFinish(childCoordinator: self)
    }
}
