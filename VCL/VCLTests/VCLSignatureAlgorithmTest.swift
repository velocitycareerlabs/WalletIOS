//
//  VCLSignatureAlgorithmTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/02/2024.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

import XCTest
@testable import VCL

class VCLSignatureAlgorithmTest: XCTestCase {
    func testFromStringAcceptsCurveNames() {
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: "P-256"), VCLSignatureAlgorithm.ES256)
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: "secp256k1"), VCLSignatureAlgorithm.SECP256k1)
    }

    func testFromStringAcceptsJwsAlgorithms() {
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: "ES256"), VCLSignatureAlgorithm.ES256)
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: "ES256K"), VCLSignatureAlgorithm.SECP256k1)
    }

    func testFromStringDefaultsToEs256() {
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: ""), VCLSignatureAlgorithm.ES256)
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: "wrong alg"), VCLSignatureAlgorithm.ES256)
        XCTAssertEqual(VCLSignatureAlgorithm.fromString(value: "es256k"), VCLSignatureAlgorithm.ES256)
    }

    func testJwsAlgorithm() {
        XCTAssertEqual(VCLSignatureAlgorithm.ES256.jwsAlgorithm, "ES256")
        XCTAssertEqual(VCLSignatureAlgorithm.SECP256k1.jwsAlgorithm, "ES256K")
    }

    func testCurve() {
        XCTAssertEqual(VCLSignatureAlgorithm.ES256.curve, "P-256")
        XCTAssertEqual(VCLSignatureAlgorithm.SECP256k1.curve, "secp256k1")
    }
}
