//
//  Keychain.swift
//  App
//
//  Created by Ricardo Rachaus on 14/07/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import Foundation
import CommonCrypto
import Security

public final class Keychain {
    
    public static let standard = Keychain()
    
    @discardableResult
    public func set(_ value: Any, forKey key: String) -> Bool {
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: value,
                                                        requiringSecureCoding: false)
            var query = setupQuery(forKey: key)
            query[kSecValueData as String] = data
            let status: OSStatus = SecItemAdd(query as CFDictionary, nil)
            
            if status == errSecDuplicateItem {
                return update(value: data, forKey: key)
            }
            return status == errSecSuccess
            
        } catch {
            print(error.localizedDescription)
        }
        
        return false
    }
    
    public func object(forKey key: String) -> Any? {
        var query = setupQuery(forKey: key)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == noErr {
            if let object = result as? Data {
                do {
                    return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(object)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    public func removeObject(forKey key: String) {
        let query = setupQuery(forKey: key)
        _ = SecItemDelete(query as CFDictionary)
    }

    private func update(value: Data, forKey key: String) -> Bool {
        let query: [String: Any] = setupQuery(forKey: key)
        let updateDictionary = [kSecValueData as String: value]
        let status: OSStatus = SecItemUpdate(query as CFDictionary, updateDictionary as CFDictionary)
        return status == errSecSuccess
    }

    private func setupQuery(forKey key: String) -> [String: Any] {
        var keychainQueryDictionary: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        let encodedIdentifier: Data? = key.data(using: String.Encoding.utf8)
        keychainQueryDictionary[kSecAttrGeneric as String] = encodedIdentifier
        keychainQueryDictionary[kSecAttrAccount as String] = encodedIdentifier
        return keychainQueryDictionary
    }
    
}

