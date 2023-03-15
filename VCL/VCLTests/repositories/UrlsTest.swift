//
//  UrlsTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/09/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class UrlsTest: XCTestCase {
    
    var subject: Urls!
    
    override func setUp() {
    }
    
    func testProdEnvironment() {
        let expectedUrlPrefix = "https://registrar.velocitynetwork.foundation"

        GlobalConfig.CurrentEnvironment = VCLEnvironment.PROD

        assert(Urls.CredentialTypes.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypeSchemas.hasPrefix(expectedUrlPrefix))
        assert(Urls.Countries.hasPrefix(expectedUrlPrefix))
        assert(Urls.Organizations.hasPrefix(expectedUrlPrefix))
        assert(Urls.ResolveKid.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypesFormSchema.hasPrefix(expectedUrlPrefix))
    }

    func testStagingEnvironment() {
        let expectedUrlPrefix = "https://stagingregistrar.velocitynetwork.foundation"

        GlobalConfig.CurrentEnvironment = VCLEnvironment.STAGING

        assert(Urls.CredentialTypes.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypeSchemas.hasPrefix(expectedUrlPrefix))
        assert(Urls.Countries.hasPrefix(expectedUrlPrefix))
        assert(Urls.Organizations.hasPrefix(expectedUrlPrefix))
        assert(Urls.ResolveKid.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypesFormSchema.hasPrefix(expectedUrlPrefix))
    }
    
    func testQaEnvironment() {
        let expectedUrlPrefix = "https://qaregistrar.velocitynetwork.foundation"

        GlobalConfig.CurrentEnvironment = VCLEnvironment.QA

        assert(Urls.CredentialTypes.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypeSchemas.hasPrefix(expectedUrlPrefix))
        assert(Urls.Countries.hasPrefix(expectedUrlPrefix))
        assert(Urls.Organizations.hasPrefix(expectedUrlPrefix))
        assert(Urls.ResolveKid.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypesFormSchema.hasPrefix(expectedUrlPrefix))
    }

    func testDevEnvironment() {
        let expectedUrlPrefix = "https://devregistrar.velocitynetwork.foundation"

        GlobalConfig.CurrentEnvironment = VCLEnvironment.DEV

        assert(Urls.CredentialTypes.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypeSchemas.hasPrefix(expectedUrlPrefix))
        assert(Urls.Countries.hasPrefix(expectedUrlPrefix))
        assert(Urls.Organizations.hasPrefix(expectedUrlPrefix))
        assert(Urls.ResolveKid.hasPrefix(expectedUrlPrefix))
        assert(Urls.CredentialTypesFormSchema.hasPrefix(expectedUrlPrefix))
    }
    
    func testVersion() {
        assert(HeaderValues.XVnfProtocolVersion == "2.0")
    }
    
    override func tearDown() {
    }
}
