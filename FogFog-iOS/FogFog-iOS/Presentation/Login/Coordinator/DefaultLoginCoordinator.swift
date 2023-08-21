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
        let viewModel = LoginViewModel(coordinator: coordinator) { oauthProviderType in
            let oauthService = oauthProviderType.service
            let authService = AuthAPIService(oauthService: oauthService)
            return authService
        }
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func showMakeNicknameViewController(to type: MakeNicknameViewType) {
        let makeNicknameViewModel = MakeNicknameViewModel(coordinator: self)
        let makeNicknameController = MakeNicknameViewController(viewModel: makeNicknameViewModel)
        navigationController.pushViewController(makeNicknameController, animated: true)
        makeNicknameController.setNaviTitle(type)
    }
    
    func connectMapCoordinator() {
        let mapCoordinator = DefaultMapCoordinator(self.navigationController)
        mapCoordinator.start()
        self.childCoordinators.append(mapCoordinator)
    }
    
    func finish() {
        finishDelegate?
            .didFinish(childCoordinator: self)
    }
}
