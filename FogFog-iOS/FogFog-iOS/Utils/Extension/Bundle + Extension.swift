//
//  Bundle + Extension.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/16.
//

import Foundation

extension Bundle {
    
    var apiKey: String {
        
        guard let file = self.path(forResource: "GoogleMap", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["API_KEY"] as? String else { fatalError("API_KEY를 설정해주세요")}
        return key
    }}

