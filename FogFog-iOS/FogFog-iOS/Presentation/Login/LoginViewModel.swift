//
//  LoginViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class LoginViewModel {
    
    private weak var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }
}
