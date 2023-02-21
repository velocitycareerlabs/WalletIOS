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
    
    func testGetVerifiedProfileIssuerSuccess() {
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr)
            ),
            EmptyExecutor()
        )

        var result: VCLResult<VCLVerifiedProfile>? = nil

        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            result = $0
        }

        do {
            let verifiedProfile = try result!.get()
            
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }

    func testGetVerifiedProfileIssuerInspector1Success() {
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
            ),
            EmptyExecutor()
        )

        var result: VCLResult<VCLVerifiedProfile>? = nil

        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            result = $0
        }

        do {
            let verifiedProfile = try result!.get()
            
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }

    func testGetVerifiedProfileIssuerInspector2Success() {
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
            ),
            EmptyExecutor()
        )

        var result: VCLResult<VCLVerifiedProfile>? = nil

        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            result = $0
        }

        do {
            let verifiedProfile = try result!.get()
            
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }

    func testGetVerifiedProfileIssuerNotaryIssuer2Success() {
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
            ),
            EmptyExecutor()
        )

        var result: VCLResult<VCLVerifiedProfile>? = nil

        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            result = $0
        }

        do {
            let verifiedProfile = try result!.get()
            
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }

    func testGetVerifiedProfileIssuerNotaryIssuerSuccess() {
        subject = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
            ),
            EmptyExecutor()
        )

        var result: VCLResult<VCLVerifiedProfile>? = nil

        subject.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            result = $0
        }

        do {
            let verifiedProfile = try result!.get()
            
            assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
            assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
            assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
        } catch {
            XCTFail()
        }
    }
}
