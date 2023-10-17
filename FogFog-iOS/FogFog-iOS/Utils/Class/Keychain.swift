//
//  Keychain.swift
//  FogFog-iOS
//
//  Created by EUNJU on 2023/07/28.
//

import Foundation
import Security

final class Keychain {
    
    // Create
    static func create(key: String, data: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data.data(using: .utf8, allowLossyConversion: false) as Any
        ]
        SecItemDelete(query) // Keychain은 Key값에 중복이 생기면 저장할 수 없기 때문에 먼저 Delete
        
        let status = SecItemAdd(query, nil)
        assert(status == noErr, "Failed to save Token")
    }
    
    // Read
    static func read(key: String) -> String? {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData: Data = dataTypeRef as? Data {
                let value = String(data: retrievedData, encoding: String.Encoding.utf8)
                return value
            } else { return nil }
        } else {
            #if DEBUG
            print("Failed to loading, status code = \(status)")
            #endif
            return nil
        }
    }
    
    // Delete
    static func delete(key: String) {
        let query: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query)
        if status != errSecSuccess {
            #if DEBUG
            print("Failed to delete")
            #endif
        }
    }
}
