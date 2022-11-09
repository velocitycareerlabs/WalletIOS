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
        subject.setCountries(key: "key", value: "country".toData(), cacheSequence: 1)
        assert(String(data: subject.getCountries(key: "key")!, encoding: .utf8) == "country")
        
        assert(subject.isResetCacheCountries(cacheSequence: 0) == false)
        assert(subject.isResetCacheCountries(cacheSequence: 1) == false)
        assert(subject.isResetCacheCountries(cacheSequence: 2))
    }

    func testGetCredentialTypes() {
        subject.setCountries(key: "key", value: "credential types".toData(), cacheSequence: 1)
        assert(String(data: subject.getCountries(key: "key")!, encoding: .utf8) == "credential types")
        
        assert(subject.isResetCacheCountries(cacheSequence: 0) == false)
        assert(subject.isResetCacheCountries(cacheSequence: 1) == false)
        assert(subject.isResetCacheCountries(cacheSequence: 2))
    }

    func testGetCredentialTypeSchema() {
        subject.setCountries(key: "key", value: "credential type schemas".toData(), cacheSequence: 1)
        assert(String(data: subject.getCountries(key: "key")!, encoding: .utf8) == "credential type schemas")
        
        assert(subject.isResetCacheCountries(cacheSequence: 0) == false)
        assert(subject.isResetCacheCountries(cacheSequence: 1) == false)
        assert(subject.isResetCacheCountries(cacheSequence: 2))
    }
    
    override func tearDown() {
    }
}
