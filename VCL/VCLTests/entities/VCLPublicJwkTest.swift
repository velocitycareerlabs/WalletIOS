//
//  VCLPublicJwkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLPublicJwkTest: XCTestCase {
    
    var subject: VCLPublicJwk!
    
    static let jwkDict = KeyServiceMocks.JWK.toDictionary()!
    
    func testPublicJwkFromStr() {
        subject = VCLPublicJwk(valueStr: KeyServiceMocks.JWK)

        assert(subject.valueStr == KeyServiceMocks.JWK)
    }

    func testPublicJwkFromJson() {
        subject = VCLPublicJwk(valueDict: VCLPublicJwkTest.jwkDict)

        assert(subject.valueDict == VCLPublicJwkTest.jwkDict)
    }
}
