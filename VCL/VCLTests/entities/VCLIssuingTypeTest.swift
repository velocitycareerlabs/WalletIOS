//
//  VCLIssuingTypeTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/02/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLIssuingTypeTest: XCTestCase {

    func testFromExactString() {
        assert(VCLIssuingType.fromString(value: "Career") == VCLIssuingType.Career)
        assert(VCLIssuingType.fromString(value: "Identity") == VCLIssuingType.Identity)
        assert(VCLIssuingType.fromString(value: "Refresh") == VCLIssuingType.Refresh)
        assert(VCLIssuingType.fromString(value: "Undefined") == VCLIssuingType.Undefined)
    }

    func testFromNonExactString() {
        assert(VCLIssuingType.fromString(value: "11_Career6_2") == VCLIssuingType.Career)
        assert(VCLIssuingType.fromString(value: "hyre_8Identity09_nf") == VCLIssuingType.Identity)
        assert(VCLIssuingType.fromString(value: "hyrek_yRefresho89#l") == VCLIssuingType.Refresh)
        assert(VCLIssuingType.fromString(value: "") == VCLIssuingType.Undefined)
    }
}
