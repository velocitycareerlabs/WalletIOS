//
//  CredentialTypeSchemasUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class CredentialTypeSchemasUseCaseTest: XCTestCase {
    
    var subject: CredentialTypeSchemasUseCase!
    
    override func setUp() {
    }
    
    func testGetCredentialTypeSchemasSuccess() {
        // Arrange
        subject = CredentialTypeSchemasUseCaseImpl(
            CredentialTypeSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialTypeSchemaMocks.CredentialTypeSchemaJson), EmptyCacheService()
            ),
            CredentialTypeSchemaMocks.CredentialTypes,
            EmptyExecutor(),
            EmptyDispatcher(),
            EmptyDsptchQueue()
        )
        
        var result: VCLResult<VCLCredentialTypeSchemas>? = nil
        
        // Action
        subject.getCredentialTypeSchemas(resetCache: false) {
            result = $0
        }
        
        // Assert
        do {
            let credentialTypeSchemas = try result?.get()
            assert((credentialTypeSchemas!.all![CredentialTypeSchemaMocks.CredentialType.schemaName!]!.payload)! == CredentialTypeSchemaMocks.CredentialTypeSchemaJson.toDictionary()!)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    override func tearDown() {
    }
}
