//
//  SmokingAreaResponse.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/09/13.
//

import Foundation

struct SmokingAreaResponseEntity: Decodable {
    let total: Int
    let areas: [SmokingAreaEntity]
    
    struct SmokingAreaEntity: Decodable {
        let id: Int
        let latitude: CGFloat
        let longitude: CGFloat
    }
}

struct SmokingAreaDetailResponseEntity: Decodable {
    let name: String
    let address: String
    let image: String
    let distance: String
}
