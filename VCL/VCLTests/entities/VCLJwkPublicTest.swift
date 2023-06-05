//
//  VCLJwkPublicTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLJwkPublicTest: XCTestCase {
    
    var subject: VCLJwkPublic!
    
    static let jwkDict = KeyServiceMocks.JWK.toDictionary()!
    
    func testJwkPublicFromStr() {
        subject = VCLJwkPublic(valueStr: KeyServiceMocks.JWK)

        assert(subject.valueStr == KeyServiceMocks.JWK)
    }

    func testJwkPublicFromJson() {
        subject = VCLJwkPublic(valueDict: VCLJwkPublicTest.jwkDict)

        assert(subject.valueDict == VCLJwkPublicTest.jwkDict)
    }
}
