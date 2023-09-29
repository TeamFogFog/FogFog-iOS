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
        let viewModel = LoginViewModel(coordinator: self) { oauthProviderType in
            let oauthService = oauthProviderType.service
            let authService = AuthAPIService(oauthService: oauthService)
            return authService
        }
        let loginViewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func showMakeNicknameViewController() {
        let makeNicknameViewModel = MakeNicknameViewModel(coordinator: self)
        let makeNicknameController = MakeNicknameViewController(viewModel: makeNicknameViewModel)
        navigationController.pushViewController(makeNicknameController, animated: true)
        makeNicknameController.setNaviTitle(.create)
    }
    
    func finish() {
        finishDelegate?
            .didFinish(childCoordinator: self)
    }
}
