//
//  AsymmetricCryptography.swift
//  App
//
//  Created by Ricardo Rachaus on 14/07/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import CommonCrypto
import Foundation

public final class AsymmetricCryptography {

    public let keyManager: KeyManager

    public init() {
        keyManager = KeyManager()
        keyManager.createKeyPair()
    }

    // MARK: - Encryption and Decryption Methods

    public func encrypt(message: String) -> Data? {
        guard let keyReference = keyManager.publicKeyReference(),
            let messageData = message.data(using: .utf8) else {
                return nil
        }

        let textLength = messageData.count
        let textPointer = messageData.bindedUInt8Pointer
        var data = Data(count: SecKeyGetBlockSize(keyReference))
        let encryptedText = data.getUInt8MutablePointer()
        var encryptedTextLength = data.count

        let status = SecKeyEncrypt(keyReference,
                                   Constants.secPadding,
                                   textPointer,
                                   textLength,
                                   encryptedText,
                                   &encryptedTextLength)

        if status == errSecSuccess {
            return data
        }
        return nil
    }

    public func decrypt(data: Data) -> String? {
        guard let keyReference = keyManager.privateKeyReference() else {
            return nil
        }
        let encryptedText = data.uInt8Pointer
        let encryptedTextLength = data.count

        var buffer = Data(count: Constants.cypheredBufferSize)

        let textPointer = buffer.getUInt8MutablePointer()
        var textLength = buffer.count
        let status = SecKeyDecrypt(keyReference,
                                   Constants.secPadding,
                                   encryptedText,
                                   encryptedTextLength,
                                   textPointer,
                                   &textLength)

        if status == errSecSuccess {
            buffer.count = textLength
            if let string = String(data: buffer, encoding: .utf8) {
                return string
            }
        }
        return nil
    }

}
