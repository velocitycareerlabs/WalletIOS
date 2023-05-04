//
//  FinalizeOffersUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class FinalizeOffersUseCaseTest: XCTestCase {
    
    var subject: FinalizeOffersUseCase!

    var token: VCLToken!
    var credentialManifestFailed: VCLCredentialManifest!
    var credentialManifestPassed: VCLCredentialManifest!
    var finalizeOffersDescriptorFailed: VCLFinalizeOffersDescriptor!
    var finalizeOffersDescriptorPassed: VCLFinalizeOffersDescriptor!
    let vclJwtFailed = VCLJwt(encodedJwt: CredentialManifestMocks.CredentialManifestJwt1)
    let vclJwtPassed = VCLJwt(encodedJwt: CredentialManifestMocks.CredentialManifestJwt2)

    override func setUp() {
        credentialManifestFailed = VCLCredentialManifest(
            jwt: vclJwtFailed
        )
        credentialManifestPassed = VCLCredentialManifest(
            jwt: vclJwtPassed
        )

        finalizeOffersDescriptorFailed = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFailed,
            approvedOfferIds: [String](),
            rejectedOfferIds: [String]()
        )
        finalizeOffersDescriptorPassed = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestPassed,
            approvedOfferIds: [String](),
            rejectedOfferIds: [String]()
        )
    }

    func testFailedredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials),
                JwtServiceRepositoryImpl(
                    JwtServiceImpl()
                )
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl()
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil

        // Action
        subject.finalizeOffers(
            token: VCLToken(value: ""),
            finalizeOffersDescriptor: finalizeOffersDescriptorFailed) {
            result = $0
        }

        // Assert
        do {
            let finalizeOffers = try result?.get()
            assert(finalizeOffers!.failedCredentials[0].encodedJwt == FinalizeOffersMocks.AdamSmithEmailJwt)
            assert(finalizeOffers!.failedCredentials[1].encodedJwt == FinalizeOffersMocks.AdamSmithDriverLicenseJwt)
            assert(finalizeOffers!.failedCredentials[2].encodedJwt == FinalizeOffersMocks.AdamSmithPhoneJwt)
            
            assert(finalizeOffers!.passedCredentials.isEmpty)
        } catch {
            XCTFail()
        }
    }
    
    func testPassedredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials),
                JwtServiceRepositoryImpl(
                    JwtServiceImpl()
                )
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl()
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil

        // Action
        subject.finalizeOffers(
            token: VCLToken(value: ""),
            finalizeOffersDescriptor: finalizeOffersDescriptorPassed) {
            result = $0
        }

        // Assert
        do {
            let finalizeOffers = try result?.get()
            assert(finalizeOffers!.passedCredentials[0].encodedJwt == FinalizeOffersMocks.AdamSmithEmailJwt)
            assert(finalizeOffers!.passedCredentials[1].encodedJwt == FinalizeOffersMocks.AdamSmithDriverLicenseJwt)
            assert(finalizeOffers!.passedCredentials[2].encodedJwt == FinalizeOffersMocks.AdamSmithPhoneJwt)
            
            assert(finalizeOffers!.failedCredentials.isEmpty)
        } catch {
            XCTFail()
        }
    }
    
    override class func tearDown() {
    }
}
