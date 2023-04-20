//
//  SmokingAreaResponseModel.swift
//  FogFog-iOS
//
//  Created by taekki on 2022/11/20.
//

import Foundation

struct SmokingAreaResponseModel: Decodable {
    let name: String
    let address: String
    let imageURLString: String
    let distance: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case address
        case imageURLString = "image"
        case distance
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.address = try container.decode(String.self, forKey: .address)
        self.imageURLString = try container.decodeIfPresent(String.self, forKey: .imageURLString) ?? "NO IMAGE"
        self.distance = try container.decode(String.self, forKey: .distance)
    }
}
