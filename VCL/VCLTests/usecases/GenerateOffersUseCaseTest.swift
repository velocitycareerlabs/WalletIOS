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
    
    private var subject1: GenerateOffersUseCase!
    private var subject2: GenerateOffersUseCase!
    private var subject3: GenerateOffersUseCase!
    
    func testGenerateOffers() {
        subject1 = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffers)
            ),
            OffersByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!),
                didJwk: DidJwkMocks.DidJwk
        ))
        subject1.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: CommonMocks.Token
        ) {
            do {
                let offers = try $0.get()
                assert(offers.all.map { $0.payload } == GenerateOffersMocks.Offers.toListOfDictionaries()!)
                assert(offers.challenge == GenerateOffersMocks.Challenge)
                assert(offers.sessionToken.value == CommonMocks.Token.value)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testGenerateOffersEmptyJsonObj() {
        subject2 = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonObj)
            ),
            OffersByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!),
                didJwk: DidJwkMocks.DidJwk
            ))

        subject2.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: CommonMocks.Token
        ) {
            do {
                let offers = try $0.get()
                assert(offers.all == "[]".toListOfDictionaries()!)
                assert(offers.sessionToken.value == CommonMocks.Token.value)
            } catch {
                XCTFail("\(error)")
            }
        }

    }
    
    func testGenerateOffersEmptyJsonArr() {
        subject3 = GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffersEmptyJsonArr)
            ),
            OffersByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!),
                didJwk: DidJwkMocks.DidJwk
            ))

        subject3.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: CommonMocks.Token
        ) {
            do {
                let offers = try $0.get()
                assert(offers.all == GenerateOffersMocks.GeneratedOffersEmptyJsonArr.toListOfDictionaries()!)
                assert(offers.sessionToken.value == CommonMocks.Token.value)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
