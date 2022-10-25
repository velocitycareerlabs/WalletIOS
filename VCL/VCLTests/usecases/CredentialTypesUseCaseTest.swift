//
//  CredentialTypesUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 04/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class CredentialTypesUseCaseTest: XCTestCase {
    var subject: CredentialTypesUseCase!
    
    override func setUp() {
    }
    
    func testCountryCodesSuccess() {
        // Arrange
        subject = CredentialTypesUseCaseImpl(
            CredentialTypesRepositoryImpl(
                NetworkServiceSuccess(
                    validResponse: CredentialTypesMocks.CredentialTypesJson
                ), EmptyCacheService()
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLCredentialTypes>? = nil
        
        // Action
        subject.getCredentialTypes(resetCache: false) {
            result = $0
        }
        
        // Assert
        do {
            compareCredentialTypes(
                credentialTypesArr1: try result!.get().all!,
                credentialTypesArr2: geExpectedCredentialTypesArr()
            )
            compareCredentialTypes(
                credentialTypesArr1: try result!.get().recommendedTypes!,
                credentialTypesArr2: geExpectedRecommendedCredentialTypesArr()
            )
        } catch {
            XCTFail()
        }
    }
    
    private func compareCredentialTypes(
        credentialTypesArr1: [VCLCredentialType],
        credentialTypesArr2: [VCLCredentialType]
    ) {
        for i in credentialTypesArr1.indices {
            assert(credentialTypesArr1[i].id == credentialTypesArr2[i].id)
            assert(credentialTypesArr1[i].schema == credentialTypesArr2[i].schema)
            assert(credentialTypesArr1[i].createdAt == credentialTypesArr2[i].createdAt)
            assert(credentialTypesArr1[i].schemaName == credentialTypesArr2[i].schemaName)
            assert(credentialTypesArr1[i].credentialType == credentialTypesArr2[i].credentialType)
            assert(credentialTypesArr1[i].recommended == credentialTypesArr2[i].recommended)
        }
    }

    private func geExpectedCredentialTypesArr() -> [VCLCredentialType] {
        var credentialTypesArr = [VCLCredentialType]()
        credentialTypesArr.append(
            VCLCredentialType(
                payload: CredentialTypesMocks.CredentialType1.toDictionary()!,
                id: "5fe4a315d8b45dd2e80bd739",
                schema: nil,
                createdAt: "2022-03-17T09:24:38.448Z",
                schemaName: "education-degree",
                credentialType: "EducationDegree",
                recommended: false
        ))
        credentialTypesArr.append(
            VCLCredentialType(
                payload: CredentialTypesMocks.CredentialType2.toDictionary()!,
                id: "5fe4a315d8b45dd2e80bd73a",
                schema: nil,
                createdAt: "2022-03-17T09:24:38.448Z",
                schemaName: "current-employment-position",
                credentialType: "CurrentEmploymentPosition",
                recommended: true
            ))
        credentialTypesArr.append(
            VCLCredentialType(
                payload: CredentialTypesMocks.CredentialType3.toDictionary()!,
                id: "5fe4a315d8b45dd2e80bd73b",
                schema: nil,
                createdAt: "2022-03-17T09:24:38.448Z",
                schemaName: "past-employment-position",
                credentialType: "PastEmploymentPosition",
                recommended: false
            ))
        return credentialTypesArr
    }

    private func geExpectedRecommendedCredentialTypesArr() -> [VCLCredentialType] {
        var credentialTypesArr = [VCLCredentialType]()
        credentialTypesArr.append(
            VCLCredentialType(
                payload: CredentialTypesMocks.CredentialType2.toDictionary()!,
                id: "5fe4a315d8b45dd2e80bd73a",
                schema: nil,
                createdAt: "2022-03-17T09:24:38.448Z",
                schemaName: "current-employment-position",
                credentialType: "CurrentEmploymentPosition",
                recommended: true
            ))
        return credentialTypesArr
    }
    
    override func tearDown() {
    }
}
