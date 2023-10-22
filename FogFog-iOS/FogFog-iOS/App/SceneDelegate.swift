//
//  SceneDelegate.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/14.
//

import UIKit

import RxSwift
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var networkMonitor: NetworkMonitor?
    var networkWindow: UIWindow?
    
    private var disposeBag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let navigationController = BaseNavigationController()
        self.appCoordinator = DefaultAppCoordinator(navigationController)
        self.appCoordinator?.start()
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        networkMonitor = NetworkMonitor()
        networkMonitor?.$status
            .subscribe(onNext: { [weak self] status in
                switch status {
                case .satisfied:
                    self?.removeNetworkConnectionView()
                    
                case .unsatisfied:
                    self?.loadNetworkConnectionView(on: scene)
                    
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        networkMonitor?.stopPathMonitor()
    }
    
    private func loadNetworkConnectionView(on scene: UIScene) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.windowLevel = .statusBar
            window.makeKeyAndVisible()
            
            let networkConnectionView = NetworkConnectionView(frame: window.bounds)
            window.addSubview(networkConnectionView)
            self.networkWindow = window
        }
    }
    
    private func removeNetworkConnectionView() {
        networkWindow?.resignKey()
        networkWindow?.isHidden = true
        networkWindow = nil
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}
