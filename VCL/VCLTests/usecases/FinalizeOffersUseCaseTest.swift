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

    override func setUp() {
//        do {
//            credentialManifest = try VCLCredentialManifest(
//                jwt: JwtServiceImpl().sign(
//                    jwtDescriptor: VCLJwtDescriptor(
//                        payload: CredentialManifestMocks.Payload,
//                        iss: "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw"
//                    )
//                )
//            )
//        } catch {
//            XCTFail("\(error)")
//        }
//
//        finalizeOffersDescriptor = VCLFinalizeOffersDescriptor(
//            didJwk: JwtServiceMocks.didJwk,
//            challenge: "some challenge",
//            credentialManifest: credentialManifest,
//            approvedOfferIds: [String](),
//            rejectedOfferIds: [String]()
//        )
    }

    func testFinalizeOffers() {
//        // Arrange
//        subject = FinalizeOffersUseCaseImpl(
//            FinalizeOffersRepositoryImpl(
//                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials),
//                JwtServiceRepositoryImpl(
//                    JwtServiceImpl()
//                )
//            ),
//            JwtServiceRepositoryImpl(
//                JwtServiceImpl()
//            ),
//            EmptyExecutor(),
//            DispatcherImpl()
//        )
//        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil
//
//        // Action
//        subject.finalizeOffers(
//            token: VCLToken(value: ""),
//            finalizeOffersDescriptor: finalizeOffersDescriptor) {
//            result = $0
//        }
//
//        // Assert
//        do {
//            let finalizeOffers = try result?.get()
//            assert(finalizeOffers!.all[0].encodedJwt == FinalizeOffersMocks.EncodedJwtVerifiableCredential)
//        } catch {
//            XCTFail()
//        }
    }
    
    override class func tearDown() {
    }
}
