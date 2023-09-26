//
//  VCLXVnfProtocolVersionTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 26/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLXVnfProtocolVersionTest: XCTestCase {
    func fromStringTest() {
        assert(VCLXVnfProtocolVersion.fromString(value: "1.0") == VCLXVnfProtocolVersion.XVnfProtocolVersion1)
        assert(VCLXVnfProtocolVersion.fromString(value: "2.0") == VCLXVnfProtocolVersion.XVnfProtocolVersion2)
        assert(VCLXVnfProtocolVersion.fromString(value: "123") == VCLXVnfProtocolVersion.XVnfProtocolVersion1) //default
    }
}
