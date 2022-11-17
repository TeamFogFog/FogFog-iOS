//
//  MapViewModel.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class MapViewModel {
    
    private weak var coordinator: MapCoordinator?
    
    init(coordinator: MapCoordinator?) {
        self.coordinator = coordinator
    }
}
