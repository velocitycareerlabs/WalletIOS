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
        XCTAssertThrowsError(try VCLJwt(encodedJwt: "")) { error in
            XCTAssertEqual((error as? VCLError)?.message, "JWT must contain header, payload, and signature")
        }
    }

    func testJwt() throws {
        subject = try VCLJwt(encodedJwt: jwtStr)

        assert(subject.header! == ("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9".decodeBase64URL()?.toDictionary())!)
        assert(subject.payload! == ("eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ".decodeBase64URL()?.toDictionary())!)
        assert(subject.signature == "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c")
        assert(subject.encodedJwt == jwtStr)
    }

    func testValidatedJwtRejectsMalformedCompactJwt() {
        XCTAssertThrowsError(try VCLJwt(validatedEncodedJwt: "not-a-jwt")) { error in
            XCTAssertEqual((error as? VCLError)?.message, "JWT must contain header, payload, and signature")
        }
    }

    func testValidatedJwtDecodesValidJwt() throws {
        subject = try VCLJwt(validatedEncodedJwt: jwtStr)

        XCTAssertEqual(subject.header! as NSDictionary, ("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9".decodeBase64URL()?.toDictionary())! as NSDictionary)
        XCTAssertEqual(subject.payload! as NSDictionary, ("eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ".decodeBase64URL()?.toDictionary())! as NSDictionary)
        XCTAssertEqual(subject.signature, "SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c")
        XCTAssertEqual(subject.encodedJwt, jwtStr)
    }
}
