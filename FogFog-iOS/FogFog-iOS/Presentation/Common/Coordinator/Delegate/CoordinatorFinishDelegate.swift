//
//  CoordinatorFinishDelegate.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/16.
//

import Foundation

protocol CoordinatorFinishDelegate: AnyObject {

    func didFinish(childCoordinator: Coordinator)
}
