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
    let jwtStr = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        
    func testEmptyJwt() {
        subject = VCLJwt(encodedJwt: "")

        assert(subject.header == nil)
        assert(subject.payload == nil)
        assert(subject.signature == nil)
        assert(subject.encodedJwt == "")
    }
    
    func testJwt() {
        subject = VCLJwt(encodedJwt: jwtStr)

        assert(subject.header! == ("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9".decodeBase64URL()?.toDictionary())!)
        assert(subject.payload! == ("eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ".decodeBase64URL()?.toDictionary())!)
        assert(subject.signature == "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c")
        assert(subject.encodedJwt == jwtStr)
    }
}
