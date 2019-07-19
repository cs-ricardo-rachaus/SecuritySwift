// swift-tools-version:5.0
//
//  SecuritySwift.swift
//  SecuritySwift
//
//  Created by Rachaus on 01/04/19.
//  Copyright © 2019 ricardorachaus. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "SecuritySwift",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2),
    ],
    products: [
        .library(
            name: "SecuritySwift",
            targets: ["SecuritySwift"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SecuritySwift",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "SecuritySwiftTests",
            dependencies: ["SecuritySwift"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
