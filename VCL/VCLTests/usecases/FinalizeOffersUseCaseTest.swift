//
//  FinalizeOffersUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 12/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class FinalizeOffersUseCaseTest: XCTestCase {
    
    var subject: FinalizeOffersUseCase!

    var offers: VCLOffers!
    var token: VCLToken!
    var didJwk: VCLDidJwk!
    let keyService = KeyServiceImpl(secretStore: SecretStoreMock.Instance)
    var credentialManifestFailed: VCLCredentialManifest!
    var credentialManifestPassed: VCLCredentialManifest!
    var finalizeOffersDescriptorFailed: VCLFinalizeOffersDescriptor!
    var finalizeOffersDescriptorPassed: VCLFinalizeOffersDescriptor!
    let vclJwtFailed = VCLJwt(encodedJwt: CredentialManifestMocks.CredentialManifestJwt1)
    let vclJwtPassed = VCLJwt(encodedJwt: CredentialManifestMocks.CredentialManifestJwt2)

    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self!.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        
        var result: VCLResult<VCLOffers>? = nil
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(jwt: CommonMocks.JWT)
        )
        GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffers)
            ),
            EmptyExecutor()
        ).generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
            result = $0
        }
        do {
            offers = try result?.get()
            assert(offers!.all == GenerateOffersMocks.Offers.toListOfDictionaries()!)
            assert(offers!.challenge == GenerateOffersMocks.Challenge)
        } catch {
            XCTFail("\(error)")
        }
        
        credentialManifestFailed = VCLCredentialManifest(
            jwt: vclJwtFailed
        )
        credentialManifestPassed = VCLCredentialManifest(
            jwt: vclJwtPassed
        )
        
        finalizeOffersDescriptorFailed = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFailed,
            offers: offers,
            approvedOfferIds: [String](),
            rejectedOfferIds: [String]()
        )
        finalizeOffersDescriptorPassed = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestPassed,
            offers: offers,
            approvedOfferIds: [String](),
            rejectedOfferIds: [String]()
        )
    }

    func testFailedCredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials)),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(keyService)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil
        
        // Action
        subject.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptorFailed,
            didJwk: didJwk,
            token: VCLToken(value: "")
        ) {
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
    
    func testPassedCredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EncodedJwtVerifiableCredentials)),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(keyService)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil

        // Action
        subject.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptorPassed,
            didJwk: didJwk,
            token: VCLToken(value: "")
        ) {
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
    
    func testEmprtyCredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: FinalizeOffersMocks.EmptyVerifiableCredentials)),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(keyService)
            ),
            EmptyExecutor(),
            DispatcherImpl()
        )
        var result: VCLResult<VCLJwtVerifiableCredentials>? = nil

        // Action
        subject.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptorPassed,
            didJwk: didJwk,
            token: VCLToken(value: "")
        ) {
            result = $0
        }

        // Assert
        do {
            let finalizeOffers = try result?.get()
            
            assert(finalizeOffers!.failedCredentials.isEmpty)
            assert(finalizeOffers!.passedCredentials.isEmpty)
        } catch {
            XCTFail()
        }
    }
    
    override class func tearDown() {
    }
}
