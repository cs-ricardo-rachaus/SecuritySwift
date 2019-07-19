//
//  Referenceable.swift
//  App
//
//  Created by Ricardo Rachaus on 17/07/19.
//  Copyright © 2019 Ricardo Rachaus. All rights reserved.
//

import Foundation

public protocol Referenceable {
    var rawPointer: UnsafeRawPointer { get }
    var nsDataRawPointer: UnsafeRawPointer { get }

    var uInt8Pointer: UnsafePointer<UInt8> { get }
    var bindedUInt8Pointer: UnsafePointer<UInt8> { get }

    mutating func mutableRawPointer() -> UnsafeMutableRawPointer
    mutating func getUInt8MutablePointer() -> UnsafeMutablePointer<UInt8>
}

extension Data: Referenceable {

    public var rawPointer: UnsafeRawPointer {
        return withUnsafeBytes { $0 }.baseAddress.unsafelyUnwrapped
    }

    public var nsDataRawPointer: UnsafeRawPointer {
        return (self as NSData).bytes
    }

    public var uInt8Pointer: UnsafePointer<UInt8> {
        return rawPointer.bindMemory(to: UInt8.self, capacity: count)
    }

    public var bindedUInt8Pointer: UnsafePointer<UInt8> {
        return nsDataRawPointer.bindMemory(to: UInt8.self, capacity: count)
    }

    mutating public func mutableRawPointer() -> UnsafeMutableRawPointer {
        return withUnsafeMutableBytes { $0 }.baseAddress.unsafelyUnwrapped
    }

    mutating public func getUInt8MutablePointer() -> UnsafeMutablePointer<UInt8> {
        let rawPointer = mutableRawPointer()
        return rawPointer.bindMemory(to: UInt8.self, capacity: count)
    }

}
