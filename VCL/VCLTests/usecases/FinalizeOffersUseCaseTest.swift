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

    var credentialManifest: VCLCredentialManifest!
    var token: VCLToken!
    var finalizeOffersDescriptor: VCLFinalizeOffersDescriptor!
    let vclJwt = VCLJwt(encodedJwt: CredentialManifestMocks.CredentialManifestJwt)

    override func setUp() {
        credentialManifest = VCLCredentialManifest(
            jwt: vclJwt
        )

        finalizeOffersDescriptor = VCLFinalizeOffersDescriptor(
            didJwk: JwtServiceMocks.didJwk,
            challenge: "some challenge",
            credentialManifest: credentialManifest,
            approvedOfferIds: [String](),
            rejectedOfferIds: [String]()
        )
    }

    func testFinalizeOffers() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials),
                JwtServiceRepositoryImpl(
                    JwtServiceSuccess(VclJwt: vclJwt, VclDidJwk: JwtServiceMocks.didJwk)
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
            finalizeOffersDescriptor: finalizeOffersDescriptor) {
            result = $0
        }

        // Assert
        do {
            let finalizeOffers = try result?.get()
            assert(finalizeOffers!.all[0].encodedJwt == FinalizeOffersMocks.EncodedJwtVerifiableCredential)
        } catch {
            XCTFail()
        }
    }
    
    override class func tearDown() {
    }
}
