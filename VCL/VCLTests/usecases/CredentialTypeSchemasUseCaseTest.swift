//
//  CredentialTypeSchemasUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class CredentialTypeSchemasUseCaseTest: XCTestCase {
    
    private var subject: CredentialTypeSchemasUseCase!
    
    func testGetCredentialTypeSchemasSuccess() {
        subject = CredentialTypeSchemasUseCaseImpl(
            CredentialTypeSchemaRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialTypeSchemaMocks.CredentialTypeSchemaJson), EmptyCacheService()
            ),
            CredentialTypeSchemaMocks.CredentialTypes,
            EmptyExecutor(),
            DispatcherImpl()
        )
                
        subject.getCredentialTypeSchemas(cacheSequence: 1) {
            do {
                let credentialTypeSchemas = try $0.get()
                assert((credentialTypeSchemas.all![CredentialTypeSchemaMocks.CredentialType.schemaName!]!.payload)! == CredentialTypeSchemaMocks.CredentialTypeSchemaJson.toDictionary()!)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
