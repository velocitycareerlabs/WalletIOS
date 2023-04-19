//
//  OrganizationsUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 01/07/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class OrganizationsUseCaseTest: XCTestCase {
    
    var subject: OrganizationsUseCase!
    
    override func setUp() {
    }

    func testCountryCodesSuccess() {
        // Arrange
        subject = OrganizationsUseCaseImpl(
            OrganizationsRepositoryImpl(
                NetworkServiceSuccess(
                    validResponse: OrganizationsMocks.OrganizationJsonResult
                )
            ),
            EmptyExecutor()
        )
        let serviceDictMock = OrganizationsMocks.IssuingServiceJsonStr.toDictionary()
        var result: VCLResult<VCLOrganizations>? = nil

        // Action
        subject.searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor(query: "")){
            result = $0
        }
        
        // Assert
        do {
            let serviceCredentialAgentIssuer = (try result?.get().all[0].serviceCredentialAgentIssuers[0])!
            assert(serviceCredentialAgentIssuer.payload == serviceDictMock!)
            assert(serviceCredentialAgentIssuer.id == serviceDictMock![VCLService.CodingKeys.KeyId] as! String)
            assert(serviceCredentialAgentIssuer.type == serviceDictMock![VCLService.CodingKeys.KeyType] as! String)
            assert(serviceCredentialAgentIssuer.credentialTypes == (serviceDictMock![VCLService.CodingKeys.KeyCredentialTypes] as! [String]))
            assert(serviceCredentialAgentIssuer.serviceEndpoint == OrganizationsMocks.IssuingServiceEndpoint)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    override func tearDown() {
    }
}
