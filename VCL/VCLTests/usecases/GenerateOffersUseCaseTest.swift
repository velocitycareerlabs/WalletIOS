//
//  GenerateOffersUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 11/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

/// TODO: Test after updating Micrisoft jwt library
final class GenerateOffersUseCaseTest: XCTestCase {
    
    var subject: GenerateOffersUseCase!

    override func setUp() {
    }
    
    func testGenerateOffers() {
//        // Arrange
//        subject = GenerateOffersUseCaseImpl(
//            GenerateOffersRepositoryImpl(
//                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffers)
//            ),
//            EmptyExecutor()
//        )
//        var result: VCLResult<VCLOffers>? = nil
//        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
//            didJwk: JwtServiceMocks.didJwk,
//            credentialManifest: VCLCredentialManifest(jwt: VCLJwt(encodedJwt: "")),
//            identificationVerifiableCredentials: [VCLVerifiableCredential]()
//        )
//
//        // Action
//        subject.generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
//            result = $0
//        }
//
//        // Assert
//        do {
//            let offers = try result?.get()
//            assert(offers!.all == GenerateOffersMocks.GeneratedOffers.toListOfDictionaries()!)
//            assert(offers!.challenge == GenerateOffersMocks.Challenge)
//        } catch {
//            XCTFail("\(error)")
//        }
    }
    
    func testGenerateOffersEmptyJsonObj() {
//        // Arrange
//        subject = GenerateOffersUseCaseImpl(
//            GenerateOffersRepositoryImpl(
//                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonObj)
//            ),
//            EmptyExecutor()
//        )
//        var result: VCLResult<VCLOffers>? = nil
//        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
//            didJwk: JwtServiceMocks.didJwk,
//            credentialManifest: VCLCredentialManifest(jwt: VCLJwt(encodedJwt: "")
//                                                     ),
//            identificationVerifiableCredentials: [VCLVerifiableCredential]()
//        )
//
//        // Action
//        subject.generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
//            result = $0
//        }
//
//        // Assert
//        do {
//            let offers = try result?.get()
//            assert(offers!.all == "[]".toListOfDictionaries()!)
//        } catch {
//            XCTFail("\(error)")
//        }
    }
    
    func testGenerateOffersEmptyJsonArr() {
//        // Arrange
//        subject = GenerateOffersUseCaseImpl(
//            GenerateOffersRepositoryImpl(
//                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonArr)
//            ),
//            EmptyExecutor()
//        )
//        var result: VCLResult<VCLOffers>? = nil
//        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
//            didJwk: JwtServiceMocks.didJwk,
//            credentialManifest: VCLCredentialManifest(jwt: VCLJwt(encodedJwt: "")
//                                                     ),
//            identificationVerifiableCredentials: [VCLVerifiableCredential]()
//        )
//
//        // Action
//        subject.generateOffers(token: VCLToken(value: ""), generateOffersDescriptor: generateOffersDescriptor) {
//            result = $0
//        }
//
//        // Assert
//        do {
//            let offers = try result?.get()
//            assert(offers!.all == GenerateOffersMocks.GeneratedOffersEmptyJsonArr.toListOfDictionaries()!)
//        } catch {
//            XCTFail("\(error)")
//        }
    }
    
    override class func tearDown() {
    }
}
