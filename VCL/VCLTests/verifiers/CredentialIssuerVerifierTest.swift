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

    private var subject1: CredentialIssuerVerifier!
    private var subject2: CredentialIssuerVerifier!
    private var subject3: CredentialIssuerVerifier!
    private var subject4: CredentialIssuerVerifier!
    private var subject5: CredentialIssuerVerifier!
    private var subject6: CredentialIssuerVerifier!
    private var subject7: CredentialIssuerVerifier!
    private var subject8: CredentialIssuerVerifier!
    private var subject9: CredentialIssuerVerifier!
    private var subject10: CredentialIssuerVerifier!
    private var subject11: CredentialIssuerVerifier!
    private var subject12: CredentialIssuerVerifier!
    private var subject13: CredentialIssuerVerifier!
    private var subjectQa: CredentialIssuerVerifier!

    private let OffersMock = VCLOffers(payload: [:], all: [], responseCode: 1, sessionToken: VCLToken(value: ""), challenge: "")

    private var finalizeOffersDescriptorWithoutPermittedServices: VCLFinalizeOffersDescriptor!
    private var credentialManifestWithoutPermittedServices: VCLCredentialManifest!

    private var finalizeOffersDescriptorOfNotaryIssuer: VCLFinalizeOffersDescriptor!
    private var credentialManifestFromNotaryIssuer: VCLCredentialManifest!

    private var finalizeOffersDescriptorOfRegularIssuer: VCLFinalizeOffersDescriptor!
    private var credentialManifestFromRegularIssuer: VCLCredentialManifest!

    private var finalizeOffersDescriptorOfIdentityIssuer: VCLFinalizeOffersDescriptor!
    private var credentialManifestFromIdentityIssuer: VCLCredentialManifest!
    
    private var finalizeOffersDescriptorOfMicrosoftQa: VCLFinalizeOffersDescriptor!
    private var CredentialManifestForValidCredentialMicrsoftQa: VCLCredentialManifest!
    private var CredentialManifestForInvalidCredentialMicrsoftQa: VCLCredentialManifest!

    override func setUp() {
        setUpSubjectProperties()
        setUpSubjects()
    }
    
    func setUpSubjectProperties() {
        credentialManifestWithoutPermittedServices = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromNotaryIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileWithoutServices.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )
        finalizeOffersDescriptorWithoutPermittedServices = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestWithoutPermittedServices,
            challenge: OffersMock.challenge,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )

        credentialManifestFromNotaryIssuer = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromNotaryIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfNotaryIssuer.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )
        finalizeOffersDescriptorOfNotaryIssuer = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFromNotaryIssuer,
            challenge: OffersMock.challenge,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )

        credentialManifestFromRegularIssuer = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromRegularIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfRegularIssuer.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )
        finalizeOffersDescriptorOfRegularIssuer = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFromRegularIssuer,
            challenge: OffersMock.challenge,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )

        credentialManifestFromIdentityIssuer = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestFromRegularIssuer),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileOfIdentityIssuer.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )
        finalizeOffersDescriptorOfIdentityIssuer = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifestFromIdentityIssuer,
            challenge: OffersMock.challenge,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )
        
        CredentialManifestForValidCredentialMicrsoftQa = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestForValidCredentialMicrsoftQa),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerInspectorMicrosoftQa.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )
        CredentialManifestForInvalidCredentialMicrsoftQa = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifestForInvalidCredentialMicrsoftQa),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerInspectorMicrosoftQa.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )
        finalizeOffersDescriptorOfMicrosoftQa = VCLFinalizeOffersDescriptor(
            credentialManifest: CredentialManifestForValidCredentialMicrsoftQa,
            challenge: OffersMock.challenge,
            approvedOfferIds: [],
            rejectedOfferIds: []
        )
    }
    
    func setUpSubjects() {
        subject1 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject2 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject3 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject4 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject5 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject6 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject7 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject8 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject9 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryIdDocumentIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject10 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.IssuerCategoryNotaryContactIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject11 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10Jsonld)
            )
        )
        subject12 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: "")
            )
        )
        subject13 = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10JsonldWithoutPrimaryOrganization)
            )
        )
        subjectQa = CredentialIssuerVerifierImpl(
            CredentialTypesModelMock(
                issuerCategory: CredentialTypesModelMock.issuerCategoryRegularIssuer
            ),
            CredentialSubjectContextRepositoryImpl(
                NetworkServiceSuccess(validResponse: JsonLdMocks.Layer1v10JsonldQa)
            )
        )
    }
    
    func testVerifyMicrosoftValidCredentialQa() {
        subjectQa.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtValidEmploymentCredentialsFromMicrosoftQa.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfMicrosoftQa
        ) {
            do {
                let isVerified = try $0.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }

    func testVerifyMicrosoftInvalidCredentialQa() {
        subjectQa.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtInvalidEmploymentCredentialsFromMicrosoftQa.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfMicrosoftQa
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.IssuerRequiresNotaryPermission.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.IssuerRequiresNotaryPermission.rawValue)
            }
        }
    }
    
    func testVerifyOpenBadgeCredentialSuccess() {
        subject1.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsOpenBadgeValid.toJwtList()!,
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
   
//    K is null => verification passed
//    func testVerifyOpenBadgeCredentialError() {
//        subject2.verifyCredentials(
//            jwtCredentials: CredentialMocks.JwtCredentialsOpenBadgeInvalid.toJwtList()!,
//            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer,
//        ) {
//            do {
//                let isVerified = try $0.get()
//                assert(isVerified)
//            } catch {
//                XCTFail("\(error)")
//            }
//        }
//    }

    func testVerifyNotaryIssuerSuccess() {
        subject3.verifyCredentials(
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
        subject4.verifyCredentials(
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
        subject5.verifyCredentials(
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
        subject6.verifyCredentials(
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
        subject7.verifyCredentials(
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
        subject8.verifyCredentials(
            jwtCredentials: CredentialMocks.JwtCredentialsWithoutSubject.toJwtList()!,
            finalizeOffersDescriptor: finalizeOffersDescriptorOfRegularIssuer
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.InvalidCredentialSubjectContext.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.InvalidCredentialSubjectType.rawValue)
            }
        }
    }

    func testVerifyIdentityIssuerSuccess() {
        subject9.verifyCredentials(
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
        subject10.verifyCredentials(
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
        subject11.verifyCredentials(
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
        subject12.verifyCredentials(
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
        subject13.verifyCredentials(
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
