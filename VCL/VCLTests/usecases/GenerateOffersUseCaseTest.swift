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
    
    private var subject: GenerateOffersUseCase!
    
    func testGenerateOffers() {
        subject = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffers)
            ),
            OffersByDeepLinkVerifierImpl(),
            ExecutorImpl()
        )
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!)
        ))
        subject.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: VCLToken(value: "")
        ) {
            do {
                let offers = try $0.get()
                assert(offers.all == GenerateOffersMocks.Offers.toListOfDictionaries()!)
                assert(offers.challenge == GenerateOffersMocks.Challenge)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testGenerateOffersEmptyJsonObj() {
        subject = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonObj)
            ),
            OffersByDeepLinkVerifierImpl(),
            ExecutorImpl()
        )
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!)
            ))

        subject.generateOffers( 
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: VCLToken(value: "")
        ) {
            do {
                let offers = try $0.get()
                assert(offers.all == "[]".toListOfDictionaries()!)
            } catch {
                XCTFail("\(error)")
            }
        }

    }
    
    func testGenerateOffersEmptyJsonArr() {
        // Arrange
        subject = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonArr)
            ),
            OffersByDeepLinkVerifierImpl(),
            ExecutorImpl()
        )
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!)
            ))

        // Action
        subject.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: VCLToken(value: "")
        ) {
            do {
                let offers = try $0.get()
                assert(offers.all == GenerateOffersMocks.GeneratedOffersEmptyJsonArr.toListOfDictionaries()!)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    override class func tearDown() {
    }
}
