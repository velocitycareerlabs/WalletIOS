//
//  FinalizeOffersUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 12/05/2021.
//

import Foundation
import XCTest
@testable import VCL

final class FinalizeOffersUseCaseTest: XCTestCase {
    
    var subject: FinalizeOffersUseCase!

    override func setUp() {
    }
    
    func testGetCredentialManifest() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials)
            ),
            JwtServiceRepositoryImpl(
                JwtServiceSuccess(VclJwt: FinalizeOffersMocks.JwtFinalizedOffer)
            ),
            EmptyExecutor(),
            EmptyDispatcher()
        )
        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil
        let credentialManifest = VCLCredentialManifest(jwt: VCLJWT(encodedJwt: ""))
        let finalizeOffersDescriptor = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifest, approvedOfferIds: [String](), rejectedOfferIds: [String]())
        
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
