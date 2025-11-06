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
    
    private let subject1 = VerifiedProfileUseCaseImpl(
        VerifiedProfileRepositoryImpl(
            NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1)
        ),
        EmptyExecutor()
    )
    private let subject2 = VerifiedProfileUseCaseImpl(
        VerifiedProfileRepositoryImpl(
            NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
        ),
        EmptyExecutor()
    )
    private let subject3 = VerifiedProfileUseCaseImpl(
        VerifiedProfileRepositoryImpl(
            NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
        ),
        EmptyExecutor()
    )
    private let subject4 = VerifiedProfileUseCaseImpl(
        VerifiedProfileRepositoryImpl(
            NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
        ),
        EmptyExecutor()
    )
    private let subject5 = VerifiedProfileUseCaseImpl(
        VerifiedProfileRepositoryImpl(
            NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileWorkPermissionIssuerJsonStr)
        ),
        EmptyExecutor()
    )
    private let subject6 = VerifiedProfileUseCaseImpl(
        VerifiedProfileRepositoryImpl(
            NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryWorkPermissionIssuerJsonStr)
        ),
        EmptyExecutor()
    )
    
    func testGetVerifiedProfileIssuerSuccess() {
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

    func testGetVerifiedProfileIssuerInspector2Success() {
        subject2.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                self.compareVerifiedProfile(verifiedProfile: verifiedProfile)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileIssuerNotaryIssuer2Success() {
        subject3.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                self.compareVerifiedProfile(verifiedProfile: verifiedProfile)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileIssuerNotaryIssuerSuccess() {
        subject4.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                self.compareVerifiedProfile(verifiedProfile: verifiedProfile)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileWorkPermissionIssuerSuccess() {
        subject5.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                self.compareVerifiedProfile(verifiedProfile: verifiedProfile)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testGetVerifiedProfileNotaryWorkPermissionIssuerSuccess() {
        subject6.getVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(
                did: "did123"
            )
        ) {
            do {
                let verifiedProfile = try $0.get()
                
                self.compareVerifiedProfile(verifiedProfile: verifiedProfile)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func compareVerifiedProfile(verifiedProfile: VCLVerifiedProfile) {
        assert(verifiedProfile.id == VerifiedProfileMocks.ExpectedId)
        assert(verifiedProfile.logo == VerifiedProfileMocks.ExpectedLogo)
        assert(verifiedProfile.name == VerifiedProfileMocks.ExpectedName)
    }
}
