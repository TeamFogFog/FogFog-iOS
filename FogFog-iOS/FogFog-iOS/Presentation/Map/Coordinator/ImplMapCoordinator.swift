//
//  ImplMapCoordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class ImplMapCoordinator: MapCoordinator {
 
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
    
    func finish() {
        
        finishDelegate?
            .didFinish(childCoordinator: self)
    }
}
