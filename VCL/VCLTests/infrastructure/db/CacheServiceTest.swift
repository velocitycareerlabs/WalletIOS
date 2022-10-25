//
//  CacheServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 20/10/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import XCTest
@testable import VCL

class CacheServiceTest: XCTestCase {
    private var subject: CacheService!
    
    override func setUp() {
        subject = CacheServiceImpl()
    }

    func testGetCountries() {
        subject.setCountries(keyUrl: "key1", value: "value1".toData())

        assert(String(data: subject.getCountries(keyUrl: "key1")!, encoding: .utf8) == "value1")
    }

    func testGetCredentialTypes() {
        subject.setCountries(keyUrl: "key2", value: "value2".toData())

        assert(String(data: subject.getCountries(keyUrl: "key2")!, encoding: .utf8) == "value2")
    }

    func testGetCredentialTypeSchema() {
        subject.setCountries(keyUrl: "key3", value: "value3".toData())

        assert(String(data: subject.getCountries(keyUrl: "key3")!, encoding: .utf8) == "value3")
    }
    
    override func tearDown() {
    }
}
