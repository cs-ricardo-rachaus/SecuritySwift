//
//  SymmetricCryptography.swift
//  App
//
//  Created by Ricardo Rachaus on 17/07/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import Foundation
import Security
import CommonCrypto

public final class SymmetricCryptography {

    public let keyData: Data
    public let ivData: Data

    public init() {
        keyData = "12345678901234567890123456789012".data(using: .utf8)!
        ivData = "abcdefghijklmnop".data(using: .utf8)!
    }

    public func encrypt(message: Data) -> Data? {
        return crypt(data: message, keyData: keyData, ivData: ivData, operation: kCCEncrypt)
    }

    public func decrypt(message: Data) -> String? {
        let result = crypt(data: message, keyData: keyData, ivData: ivData, operation: kCCDecrypt)!
        return String(bytes: result, encoding: .utf8)
    }

    private func crypt(data: Data, keyData: Data, ivData: Data, operation: Int) -> Data? {
        let keyLength: size_t = kCCKeySizeAES128
        let algorithm: CCAlgorithm = CCAlgorithm(kCCAlgorithmAES)
        let options: CCOptions = CCOptions(kCCOptionPKCS7Padding)

        let length: size_t = data.count + kCCBlockSizeAES128
        var result = Data(count: length)
        var finalLength: size_t = 0

        let status = CCCrypt(CCOperation(operation),
                             algorithm,
                             options,
                             keyData.rawPointer,
                             keyLength,
                             ivData.rawPointer,
                             data.nsDataRawPointer,
                             data.count,
                             result.mutableRawPointer(),
                             length,
                             &finalLength)

        if status == kCCSuccess {
            result.removeSubrange(finalLength..<result.count)
            return result
        }
        return nil
    }

}
