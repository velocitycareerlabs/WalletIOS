//
//  UtilsTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 07/11/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class UtilsTest: XCTestCase {
    func testGetIdentifier() {
        let jsonObject: [String: Sendable] = [
            "a": "ValueA",
            "b": ["identifier": "ValueB"],
            "c": ["id1": "ValueC"],
            "d": ["x": "ValueX"],
            "e": ["f": ["id": "ValueD"]]
        ]

        let primaryOrgProp = "id"
        let result = Utils.getIdentifier(primaryOrgProp, jsonObject)

//        assert("ValueC" == result) // what about this case?
        assert("ValueD" == result)
    }

    func testGetIdentifierNoMatch() {
        let jsonObject: [String: Sendable] = [
            "a": "ValueA",
            "b": ["identifier": "ValueB"],
            "c": ["x": "ValueX"]
        ]

        let primaryOrgProp = "id"
        let result = Utils.getIdentifier(primaryOrgProp, jsonObject)

        assert(result == nil)
    }

    func testGetPrimaryIdentifier() {
        let value = "ValueX"
        let result = Utils.getPrimaryIdentifier(value)

        assert("ValueX" == result)
    }

    func testGetPrimaryIdentifierMapWithId() {
        let value: [String: Sendable] = ["id": "ValueY"]
        let result = Utils.getPrimaryIdentifier(value)

        assert("ValueY" == result)
    }

    func testGetPrimaryIdentifierMapWithIdentifier() {
        let value: [String: Sendable] = ["identifier": "ValueZ"]
        let result = Utils.getPrimaryIdentifier(value)

        assert("ValueZ" == result)
    }

    func testGetPrimaryIdentifierNull() {
        let value: [String: Sendable]? = nil
        let result = Utils.getPrimaryIdentifier(value)

        assert(result == nil)
    }
}
