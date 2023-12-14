//
//  CredentialIssuerVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 19/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class CredentialIssuerVerifierTest: XCTestCase {

    private var subject: CredentialIssuerVerifier!

    private let OffersMock = VCLOffers(payload: [:], all: [], responseCode: 1, sessionToken: VCLToken(value: ""), challenge: "")

    private var finalizeOffersDescriptorWithoutPermittedServices: VCLFinalizeOffersDescriptor!
    private var credentialManifestWithoutPermittedServices: VCLCredentialManifest!

    private var finalizeOffersDescriptorOfNotaryIssuer: VCLFinalizeOffersDescriptor!
    private var credentialManifestFromNotaryIssuer: VCLCredentialManifest!

    private var finalizeOffersDescriptorOfRegularIssuer: VCLFinalizeOffersDescriptor!
    private var credentialManifestFromRegularIssuer: VCLCredentialManifest!

    private var finalizeOffersDescriptorOfIdentityIssuer: VCLFinalizeOffersDescriptor!
    private var credentialManifestFromIdentityIssuer: VCLCredentialManifest!

    override func setUp() {
        credentialManifestWithoutPermittedServices = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromNotaryIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileWithoutServices.toDictionary()!)
        )
        finalizeOffersDescriptorWithoutPermittedServices = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestWithoutPermittedServices,
            offers: OffersMock,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )

        credentialManifestFromNotaryIssuer = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromNotaryIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfNotaryIssuer.toDictionary()!)
        )
        finalizeOffersDescriptorOfNotaryIssuer = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFromNotaryIssuer,
            offers: OffersMock,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )

        credentialManifestFromRegularIssuer = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromRegularIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfRegularIssuer.toDictionary()!)
        )
        finalizeOffersDescriptorOfRegularIssuer = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFromRegularIssuer,
            offers: OffersMock,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )

        credentialManifestFromIdentityIssuer = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromRegularIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfIdentityIssuer.toDictionary()!)
        )
        finalizeOffersDescriptorOfIdentityIssuer = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFromIdentityIssuer,
            offers: OffersMock,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )
    }

    func testVerifyNotaryIssuerSuccess() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromNotaryIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfNotaryIssuer
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyNotaryIssuerMissingSubjectSuccess() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsWithoutSubject.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfNotaryIssuer
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyRegularIssuerSuccess() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromRegularIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testVerifyRegularIssuerWrongDidFailed() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromNotaryIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.IssuerRequiresNotaryPermission.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.IssuerRequiresNotaryPermission.rawValue)
            }
        }
    }

    func testVerifyIssuerWithoutServicesFailed() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromNotaryIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorWithoutPermittedServices
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.CredentialTypeNotRegistered.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.CredentialTypeNotRegistered.rawValue)
            }
        }
    }

    func testVerifyRegularIssuerMissingSubjectFailed() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsWithoutSubject.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.InvalidCredentialSubjectContext.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.InvalidCredentialSubjectContext.rawValue)
            }
        }
    }

    func testVerifyIdentityIssuerSuccess() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryIdDocumentIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromRegularIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfIdentityIssuer
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyEmptyCredentialsSuccess() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryContactIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtEmptyCredentials.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfIdentityIssuer
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyIdentityIssuerFailedWithoutIdentityService() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromIdentityIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfIdentityIssuer
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.IssuerRequiresIdentityPermission.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.IssuerRequiresIdentityPermission.rawValue)
            }
        }
    }

    func testVerifyIssuerWithoutServicesFailedCompleteContextNotFound() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            NetworkServiceSuccess(validResponse: "")
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromRegularIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.InvalidCredentialSubjectContext.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.InvalidCredentialSubjectContext.rawValue)
            }
        }
    }

    func testVerifyIssuerPrimaryOrganizationNotFound() {
        subject = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10JsonldWithoutPrimaryOrganization)
        )

        subject.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsFromRegularIssuer.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
