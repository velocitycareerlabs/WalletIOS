//
//  VCLJwtTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 08/06/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLJwtTest: XCTestCase {
    
    var subject: VCLJwt!
        
    func testEmptyJwt() {
        subject = VCLJwt(encodedJwt: "")

        assert(subject.header == nil)
        assert(subject.payload == nil)
        assert(subject.signature == nil)
        assert(subject.encodedJwt == "")
    }
}
