//
//  SceneDelegate.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        // let navigationController = UINavigationController()
        // self.appCoordinator = ImplAppCoordinator(navigationController)
        // self.appCoordinator?.start()
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = RoadPopUpViewController(viewModel: RoadPopUpViewModel())
        self.window?.makeKeyAndVisible()
    }
}
