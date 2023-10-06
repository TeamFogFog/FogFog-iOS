//
//  DefaultAppCoordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class DefaultAppCoordinator: AppCoordinator {

    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .app }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        // BaseViewController에서 ViewWillAppear에 해당하는 부분인데
        // BaseViewController에서 코드를 지울지, 아래의 코드를 지울지 논의 필요
        navigationController.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(popToRoot),
            name: NotificationCenterKey.refreshTokenHasExpired,
            object: nil
        )
    }
    
    func start() {
        
        // 앱의 시작점 설정(keychain의 accessToken 저장 여부 확인)
        if Keychain.read(key: Keychain.Keys.accessToken) != nil {
            showMapFlow()
        } else {
            showLoginFlow()
        }
    }
    
    func showLoginFlow() {
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showMapFlow() {
        let mapCoordinator = DefaultMapCoordinator(self.navigationController)
        mapCoordinator.finishDelegate = self
        mapCoordinator.start()
        childCoordinators.append(mapCoordinator)
    }
    
    @objc
    func popToRoot(_ notification: Notification) {
        showLoginFlow()
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {

    func didFinish(childCoordinator: Coordinator) {
        
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .login:
            self.showMapFlow()
        case .map:
            self.showLoginFlow()
        default:
            break
        }
    }
}
