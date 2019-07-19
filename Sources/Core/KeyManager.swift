//
//  KeyManager.swift
//  App
//
//  Created by Ricardo Rachaus on 02/07/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import CommonCrypto
import Foundation

public struct Constants {
    static let applicationTag = "com.app"
    static let keyType = kSecAttrKeyTypeRSA
    static let keySize = 2048
    static let cypheredBufferSize = 1024
    static let secPadding: SecPadding = .PKCS1
}

public final class KeyManager {

    public enum KeyType {
        case publicKey
        case privateKey

        public var keyClass: CFString {
            switch self {
            case .publicKey:
                return kSecAttrKeyClassPublic
            case .privateKey:
                return kSecAttrKeyClassPrivate
            }
        }
    }

    public var publicKey: SecKey?
    public var privateKey: SecKey?

    private let defaultKeyParameters: [String: Any] = [
        kSecClass as String: kSecClassKey,
        kSecAttrKeyType as String: Constants.keyType,
        kSecAttrApplicationTag as String: Constants.applicationTag,
    ]

    // MARK: - Create keys

    @discardableResult
    public func createKeyPair() -> Bool {
        let keyParameters: [String: Any] = [
            kSecAttrIsPermanent as String: true,
            kSecAttrApplicationTag as String: Constants.applicationTag,
        ]

        let parameters: [String: Any] = [
            kSecAttrKeyType as String: Constants.keyType,
            kSecAttrKeySizeInBits as String: Constants.keySize,
            kSecPublicKeyAttrs as String: keyParameters,
            kSecPrivateKeyAttrs as String: keyParameters,
        ]

        var publicKey, privateKey: SecKey?
        let status = SecKeyGeneratePair(parameters as CFDictionary, &publicKey, &privateKey)
        return status == errSecSuccess
    }

    // MARK: - Get Keys

    public func publicKeyReference() -> SecKey? {
        let publicKeyParameters: [String: Any] = [
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecReturnRef as String: true,
        ]
        let parameters = publicKeyParameters.merge(with: defaultKeyParameters)
        return getItem(with: parameters) as! SecKey?
    }

    public func privateKeyReference() -> SecKey? {
        let privateKeyParameters: [String: Any] = [
            kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
            kSecReturnRef as String: true,
        ]
        let parameters = privateKeyParameters.merge(with: defaultKeyParameters)
        return getItem(with: parameters) as! SecKey?
    }

    // MARK: - Check if keys exists

    public func keyPairExists() -> Bool {
        return publicKeyReference() != nil
    }

    // MARK: - Delete Keys

    @discardableResult
    public func deleteKeyPair() -> Bool {
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrApplicationTag as String: Constants.applicationTag,
        ]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        return status == errSecSuccess
    }

    // MARK: - Helper

    private func getItem(with parameters: [String: Any]) -> AnyObject? {
        var reference: AnyObject?
        let status = SecItemCopyMatching(parameters as CFDictionary, &reference)
        if status == errSecSuccess {
            return reference
        }
        return nil
    }

    // MARK: - External Keys

    @discardableResult
    public func addPublicKey(_ keyString: String) -> Bool {
        publicKey = addKey(keyString: keyString, type: .publicKey)
        return publicKey != nil
    }

    @discardableResult
    public func addPrivateKey(_ keyString: String) -> Bool {
        privateKey = addKey(keyString: keyString, type: .privateKey)
        return privateKey != nil
    }


    private func addKey(keyString: String, type: KeyManager.KeyType) -> SecKey? {
        guard let keyData = Data(base64Encoded: keyString) else {
            return nil
        }

        let parameters: [String: Any] = [
            kSecAttrKeyType as String: Constants.keyType,
            kSecAttrKeySizeInBits as String: Constants.keySize,
            kSecAttrKeyClass as String: type.keyClass,
            kSecReturnPersistentRef as String: true,
        ]
        return SecKeyCreateWithData(keyData as CFData, parameters as CFDictionary, nil)
    }

}

extension Dictionary {
    func merge(with dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var newDict = self
        for (key, value) in dict {
            newDict[key] = value
        }
        return newDict
    }
}
