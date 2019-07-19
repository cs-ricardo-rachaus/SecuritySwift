//
//  SecuritySwiftSpec.swift
//  SecuritySwift
//
//  Created by Rachaus on 01/04/19.
//  Copyright © 2019 ricardorachaus. All rights reserved.
//

import Quick
import Nimble
@testable import SecuritySwift

class SecuritySwiftSpec: QuickSpec {
    override func spec() {
        describe("SecuritySwiftSpec") {
            it("works") {
                expect(SecuritySwift.name) == "SecuritySwift"
            }
        }
    }
}
