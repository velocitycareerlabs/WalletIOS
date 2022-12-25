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
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileJsonStr)
            ),
            EmptyExecutor()
        )
    }
    
    func testGetVerifiedProfileAnyServiceSuccess() {
        var result: VCLResult<VCLVerifiedProfile>? = nil
        
        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            result = $0
        }
        
        do {
            let verifiedProfile = (try result?.get())!
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }
    
    func testGetVerifiedProfileSuccess() {

        var result: VCLResult<VCLVerifiedProfile>? = nil
        
        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123",
                serviceType: VCLServiceType.Issuer
            )
        ) {
            result = $0
        }
        
        do {
            let verifiedProfile = (try result?.get())!
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }

    func testGetVerifiedProfileError() {

        var result: VCLResult<VCLVerifiedProfile>? = nil

        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123",
                serviceType: VCLServiceType.IdentityIssuer
            )
        ) {
            result = $0
        }
        
        do {
            (try result?.get())!
        } catch {
            assert((error as! VCLError).code == VCLErrorCode.VerificationError.rawValue)
        }
    }
    
    override func tearDown() {
    }
}
