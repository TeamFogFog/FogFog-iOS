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
        
    }
    
    func showMakeNicknameViewController() {
        let makeNicknameViewModel = MakeNicknameViewModel(coordinator: self)
        let makeNicknameController = MakeNicknameViewController(viewModel: makeNicknameViewModel)
        navigationController.pushViewController(makeNicknameController, animated: true)
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
