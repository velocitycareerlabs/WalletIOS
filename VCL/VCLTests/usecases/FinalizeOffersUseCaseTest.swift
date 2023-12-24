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
    
    private var subject: FinalizeOffersUseCase!
    
    private var token: VCLToken!
    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
    private var credentialManifestFailed: VCLCredentialManifest!
    private var credentialManifestPassed: VCLCredentialManifest!
    private var finalizeOffersDescriptorFailed: VCLFinalizeOffersDescriptor!
    private var finalizeOffersDescriptorPassed: VCLFinalizeOffersDescriptor!
    private let vclJwtFailed = VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifest1)
    private let vclJwtPassed = VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromRegularIssuer)
    private let credentialsAmount = CredentialMocks.JwtCredentialsFromRegularIssuer.toList()?.count
    
    override func setUp() {
        keyService.generateDidJwk { [weak self] didJwkResult in
            do {
                self?.didJwk = try didJwkResult.get()
            } catch {
                assert(false, "Failed to generate did:jwk \(error)" )
            }
        }
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: VCLCredentialManifest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr2.toDictionary()!)
            )
        )
        GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: GenerateOffersMocks.GeneratedOffers)
            ),
            OffersByDeepLinkVerifierImpl(),
            EmptyExecutor()
        ).generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: VCLToken(value: "")
        ) { result in
            do {
                let offers = try result.get()
//            TODO: FIX
//                assert(
//                    offers.all == GenerateOffersMocks.Offers.toListOfDictionaries()!//???
//                )
                assert(offers.challenge == GenerateOffersMocks.Challenge)
                
                self.credentialManifestFailed = VCLCredentialManifest(
                    jwt: self.vclJwtFailed,
                    verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr2.toDictionary()!)
                )
                self.credentialManifestPassed = VCLCredentialManifest(
                    jwt: self.vclJwtPassed,
                    verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr2.toDictionary()!)
                )
                
                self.finalizeOffersDescriptorFailed = VCLFinalizeOffersDescriptor(
                    credentialManifest: self.credentialManifestFailed,
                    offers: offers,
                    approvedOfferIds: [],
                    rejectedOfferIds: []
                )
                self.finalizeOffersDescriptorPassed = VCLFinalizeOffersDescriptor(
                    credentialManifest: self.credentialManifestPassed!,
                    offers: offers,
                    approvedOfferIds: [],
                    rejectedOfferIds: []
                )
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testFailedCredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialMocks.JwtCredentialsFromRegularIssuer)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(keyService),
                VCLJwtVerifyServiceLocalImpl()
            ),
            CredentialIssuerVerifierImpl(
                CredentialTypesModelMock(
                    issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
                ),
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            ),
            CredentialDidVerifierImpl(),
            CredentialsByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        
        subject.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptorFailed,
            didJwk: didJwk,
            sessionToken: VCLToken(value: ""),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let finalizeOffers = try $0.get()
                assert(finalizeOffers.failedCredentials.count == self.credentialsAmount)
                assert(
                    finalizeOffers.failedCredentials.first { cred in
                        cred.encodedJwt == CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer
                    } != nil
                )
                assert(
                    finalizeOffers.failedCredentials.first { cred in
                        cred.encodedJwt == CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer
                    } != nil
                )
                assert(finalizeOffers.passedCredentials.isEmpty)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testPassedCredentials() {
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialMocks.JwtCredentialsFromRegularIssuer)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(keyService),
                VCLJwtVerifyServiceLocalImpl()
            ),
            CredentialIssuerVerifierImpl(
                CredentialTypesModelMock(
                    issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
                ),
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            ),
            CredentialDidVerifierImpl(),
            CredentialsByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        
        subject.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptorPassed,
            didJwk: didJwk,
            sessionToken: VCLToken(value: ""),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let finalizeOffers = try $0.get()
                assert(finalizeOffers.passedCredentials.count == self.credentialsAmount)
                assert(
                    finalizeOffers.passedCredentials.first { cred in
                        cred.encodedJwt == CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer
                    } != nil
                )
                assert(
                    finalizeOffers.passedCredentials.first { cred in
                        cred.encodedJwt == CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer
                    } != nil
                )
                assert(finalizeOffers.failedCredentials.isEmpty)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testEmptyCredentials() {
        // Arrange
        subject = FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialMocks.JwtEmptyCredentials)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(keyService),
                VCLJwtVerifyServiceLocalImpl()
            ),
            CredentialIssuerVerifierImpl(
                CredentialTypesModelMock(
                    issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
                ),
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            ),
            CredentialDidVerifierImpl(),
            CredentialsByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        
        subject.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptorPassed,
            didJwk: didJwk,
            sessionToken: VCLToken(value: ""),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let finalizeOffers = try $0.get()
                assert(finalizeOffers.failedCredentials.isEmpty)
                assert(finalizeOffers.passedCredentials.isEmpty)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
