//
//  GenerateOffersUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class GenerateOffersUseCaseTest: XCTestCase {
    
    var subject: GenerateOffersUseCase!

    override func setUp() {
    }
    
    func testGenerateOffers() {
        // Arrange
        subject = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.Offers)
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLOffers>? = nil
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(jwt: VCLJwt(encodedJwt: "")),
            identificationVerifiableCredentials: [VCLVerifiableCredential]()
        )

        // Action
        subject.generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
            result = $0
        }

        // Assert
        do {
            let offers = try result?.get()
            assert(offers!.all == GenerateOffersMocks.Offers.toListOfDictionaries()!)
//            assert(offers!.challenge == GenerateOffersMocks.Challenge)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGenerateOffersEmptyJsonObj() {
        // Arrange
        subject = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonObj)
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLOffers>? = nil
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(jwt: VCLJwt(encodedJwt: "")
                                                     ),
            identificationVerifiableCredentials: [VCLVerifiableCredential]()
        )

        // Action
        subject.generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
            result = $0
        }

        // Assert
        do {
            let offers = try result?.get()
            assert(offers!.all == "[]".toListOfDictionaries()!)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testGenerateOffersEmptyJsonArr() {
        // Arrange
        subject = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonArr)
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLOffers>? = nil
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(jwt: VCLJwt(encodedJwt: "")
                                                     ),
            identificationVerifiableCredentials: [VCLVerifiableCredential]()
        )

        // Action
        subject.generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
            result = $0
        }

        // Assert
        do {
            let offers = try result?.get()
            assert(offers!.all == GenerateOffersMocks.GeneratedOffersEmptyJsonArr.toListOfDictionaries()!)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    override class func tearDown() {
    }
}
