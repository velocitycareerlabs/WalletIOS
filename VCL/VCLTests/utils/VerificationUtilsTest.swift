//
//  VerificationUtilsTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 07/11/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VerificationUtilsTest: XCTestCase {
    func testGetIdentifier() {
        let jsonObject: [String: AnyHashable] = [
            "a": "ValueA",
            "b": ["identifier": "ValueB"],
            "c": ["id1": "ValueC"],
            "d": ["x": "ValueX"],
            "e": ["f": ["id": "ValueD"]]
        ]

        let primaryOrgProp = "id"
        let result = VerificationUtils.getIdentifier(primaryOrgProp, jsonObject)

//        assert("ValueC" == result) // what about this case?
        assert("ValueD" == result)
    }

    func testGetIdentifierNoMatch() {
        let jsonObject: [String: AnyHashable] = [
            "a": "ValueA",
            "b": ["identifier": "ValueB"],
            "c": ["x": "ValueX"]
        ]

        let primaryOrgProp = "id"
        let result = VerificationUtils.getIdentifier(primaryOrgProp, jsonObject)

        assert(result == nil)
    }

    func testGetPrimaryIdentifier() {
        let value = "ValueX"
        let result = VerificationUtils.getPrimaryIdentifier(value)

        assert("ValueX" == result)
    }

    func testGetPrimaryIdentifierMapWithId() {
        let value = ["id": "ValueY"]
        let result = VerificationUtils.getPrimaryIdentifier(value)

        assert("ValueY" == result)
    }

    func testGetPrimaryIdentifierMapWithIdentifier() {
        let value = ["identifier": "ValueZ"]
        let result = VerificationUtils.getPrimaryIdentifier(value)

        assert("ValueZ" == result)
    }

    func testGetPrimaryIdentifierNull() {
        let value: [String: AnyHashable]? = nil
        let result = VerificationUtils.getPrimaryIdentifier(value)

        assert(result == nil)
    }
}
