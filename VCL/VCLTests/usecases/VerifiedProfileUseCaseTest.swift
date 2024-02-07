//
//  VerifiedProfileUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 28/10/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VerifiedProfileUseCaseTest: XCTestCase {
    
    private var subject1: VerifiedProfileUseCase!
    private var subject2: VerifiedProfileUseCase!
    private var subject3: VerifiedProfileUseCase!
    private var subject4: VerifiedProfileUseCase!
    private var subject5: VerifiedProfileUseCase!
    
    func testGetVerifiedProfileIssuerSuccess() {
        subject1 = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1)
            ),
            EmptyExecutor()
        )
        subject1.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
                assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
                assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileIssuerInspector1Success() {
        subject2 = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
            ),
            EmptyExecutor()
        )

        subject2.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
                assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
                assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileIssuerInspector2Success() {
        subject3 = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
            ),
            EmptyExecutor()
        )

        subject3.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
                assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
                assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileIssuerNotaryIssuer2Success() {
        subject4 = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
            ),
            EmptyExecutor()
        )
        
        subject4.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
                assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
                assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileIssuerNotaryIssuerSuccess() {
        subject5 = VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
            ),
            EmptyExecutor()
        )
        
        subject5.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
                assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
                assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
