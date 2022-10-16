//
//  VerifiedProfileUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 28/10/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VerifiedProfileUseCaseTest: XCTestCase {
    
    var subject: VerifiedProfileUseCase!
    
    override func setUp() {
    }
    
    func testGetVerifiedProfile() {
        // Arrange
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(
                    validResponse: VerifiedProfileMocks.VerifiedProfileJsonStr
                )
            ), EmptyExecutor()
        )
        
        var result: VCLResult<VCLVerifiedProfile>? = nil
        
        // Action
        subject.getVerifiedProfile(verifiedProfileDescriptor: VerifiedProfileMocks.VerifiedProfileDescriptor) {
            result = $0
        }
        
        // Assert
        do {
            let verifiedProfile = (try result?.get())!
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
    }
}
