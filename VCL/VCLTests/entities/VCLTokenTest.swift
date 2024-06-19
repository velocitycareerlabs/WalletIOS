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
        subject = VCLToken(value: TokenMocks.TokenStr)
        
        assert(subject.value == TokenMocks.TokenStr)
        assert(subject.jwtValue.encodedJwt == TokenMocks.TokenStr)
        assert(subject.expiresIn == 1704020514)
    }
    
    func testToken2() {
        subject = VCLToken(jwtValue: TokenMocks.TokenJwt)
        
        assert(subject.value == TokenMocks.TokenJwt.encodedJwt)
        assert(subject.jwtValue.encodedJwt == TokenMocks.TokenJwt.encodedJwt)
        assert(subject.expiresIn == 1704020514)
    }
}
