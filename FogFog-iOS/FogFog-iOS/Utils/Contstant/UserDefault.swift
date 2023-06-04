//
//  UserDefault.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/06/04.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    
    private let key: String
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: key) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
