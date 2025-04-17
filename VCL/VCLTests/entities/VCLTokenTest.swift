//
//  VCLTokenTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 24/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLTokenTest: XCTestCase {
    var subject: VCLToken!
    
    func testToken1() {
        subject = VCLToken(value: TokenMocks.TokenStr1)
        
        assert(subject.value == TokenMocks.TokenStr1)
        assert(subject.jwtValue.encodedJwt == TokenMocks.TokenStr1)
        assert(subject.expiresIn == 1704020514)
    }
    
    func testToken2() {
        subject = VCLToken(jwtValue: TokenMocks.TokenJwt1)
        
        assert(subject.value == TokenMocks.TokenJwt1.encodedJwt)
        assert(subject.jwtValue.encodedJwt == TokenMocks.TokenJwt1.encodedJwt)
        assert(subject.expiresIn == 1704020514)
    }
}
