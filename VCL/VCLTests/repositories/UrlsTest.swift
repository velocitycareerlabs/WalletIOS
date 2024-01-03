//
//  UrlsTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/09/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class UrlsTest: XCTestCase {
    
    var subject: Urls!
    
    override func setUp() {
    }
    
    func testProdEnvironment() {
        let registrarPrefix = "https://registrar.velocitynetwork.foundation"
        
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Prod

        verifyUrlsPrefix(registrarPrefix)
    }

    func testStagingEnvironment() {
        let registrarPrefix = "https://stagingregistrar.velocitynetwork.foundation"
        
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Staging

        verifyUrlsPrefix(registrarPrefix)
    }
    
    func testQaEnvironment() {
        let registrarPrefix = "https://qaregistrar.velocitynetwork.foundation"
        
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Qa

        verifyUrlsPrefix(registrarPrefix)
    }

    func testDevEnvironment() {
        let registrarPrefix = "https://devregistrar.velocitynetwork.foundation"

        GlobalConfig.CurrentEnvironment = VCLEnvironment.Dev

        verifyUrlsPrefix(registrarPrefix)
    }
    
    private func verifyUrlsPrefix(_ registrarPrefix: String) {
        assert(Urls.CredentialTypes.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.CredentialTypes)")
        assert(Urls.ServiceTypes.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.ServiceTypes)")
        assert(Urls.CredentialTypeSchemas.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.CredentialTypeSchemas)")
        assert(Urls.Countries.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.Countries)")
        assert(Urls.Organizations.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.Organizations)")
        assert(Urls.ResolveKid.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.ResolveKid)")
        assert(Urls.CredentialTypesFormSchema.hasPrefix(registrarPrefix), "expected: \(registrarPrefix), actual: \(Urls.CredentialTypesFormSchema)")
    }
    
    func testXVnfProtocolVersion() {
        GlobalConfig.XVnfProtocolVersion = .XVnfProtocolVersion1
        assert(HeaderValues.XVnfProtocolVersion == "1.0")
        
        GlobalConfig.XVnfProtocolVersion = .XVnfProtocolVersion2
        assert(HeaderValues.XVnfProtocolVersion == "2.0")
    }
    
    override func tearDown() {
    }
}
