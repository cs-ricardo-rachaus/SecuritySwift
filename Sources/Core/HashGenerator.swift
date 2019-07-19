//
//  HashGenerator.swift
//  App
//
//  Created by Ricardo Rachaus on 14/07/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import Foundation
import CommonCrypto

public final class HashGenerator {
    
    public static func sha512(value: Data) -> String {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA512_DIGEST_LENGTH))
        CC_SHA512(value.rawPointer, CC_LONG(value.count), &hash)
        return Data(hash).base64EncodedString()
    }
    
}
