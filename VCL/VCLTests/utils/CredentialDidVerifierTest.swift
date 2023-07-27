//
//  CredentialDidVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 19/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class CredentialDidVerifierTest: XCTestCase {
    private let subject = CredentialDidVerifierImpl()
        private let credentialsFromNotaryIssuerAmount =
    CredentialMocks.JwtCredentialsFromNotaryIssuer.toList()?.count ?? 0
        private let credentialsFromRegularIssuerAmount =
    CredentialMocks.JwtCredentialsFromRegularIssuer.toList()?.count ?? 0
    private let OffersMock = VCLOffers(payload: [String: Any](), all: [[String: Any]](), responseCode: 1, token: VCLToken(value: ""), challenge: "")

        var finalizeOffersDescriptorOfNotaryIssuer: VCLFinalizeOffersDescriptor!
        var credentialManifestFromNotaryIssuer: VCLCredentialManifest!

        var finalizeOffersDescriptorOfRegularIssuer: VCLFinalizeOffersDescriptor!
        var credentialManifestFromRegularIssuer: VCLCredentialManifest!

        override func setUp() {
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
        }

        func testVerifyCredentialsSuccess() {
            subject.verifyCredentials(
                jwtEncodedCredentials: CredentialMocks.JwtCredentialsFromNotaryIssuer.toList()! as! [String],
                finalizeOffersDescriptor: finalizeOffersDescriptorOfNotaryIssuer
            ) {
                do {
                    let verifiableCredentials = try $0.get()
                    assert(verifiableCredentials.passedCredentials.count == self.credentialsFromNotaryIssuerAmount)
                    assert(
                        verifiableCredentials.passedCredentials.first {
                            $0.encodedJwt == CredentialMocks.JwtCredentialEmploymentPastFromNotaryIssuer
                        } != nil
                    )
                    assert(
                        verifiableCredentials.passedCredentials.first {
                            $0.encodedJwt == CredentialMocks.JwtCredentialEducationDegreeRegistrationFromNotaryIssuer
                        } != nil
                    )
                    assert(verifiableCredentials.failedCredentials.isEmpty)
                } catch {
                    XCTFail("\(error)")
                }
            }
        }

        func testVerifyCredentialsFailed() {
            subject.verifyCredentials(
                jwtEncodedCredentials: CredentialMocks.JwtCredentialsFromRegularIssuer.toList() as! [String],
                finalizeOffersDescriptor: finalizeOffersDescriptorOfNotaryIssuer
            ) {
                do {
                    let verifiableCredentials = try $0.get()
                    assert(verifiableCredentials.failedCredentials.count == self.credentialsFromRegularIssuerAmount)
                    assert(
                        verifiableCredentials.failedCredentials.first {
                            $0.encodedJwt == CredentialMocks.JwtCredentialEmploymentPastFromRegularIssuer
                        } != nil
                    )
                    assert(
                        verifiableCredentials.failedCredentials.first {
                            $0.encodedJwt == CredentialMocks.JwtCredentialEducationDegreeRegistrationFromRegularIssuer
                        } != nil
                    )
                    assert(verifiableCredentials.passedCredentials.isEmpty)
                } catch {
                    XCTFail("\(error)")
                }
            }
        }

        func testVerifyCredentials1Passed1Failed() {
            subject.verifyCredentials(
                jwtEncodedCredentials: "[\"\(CredentialMocks.JwtCredentialEmploymentPastFromNotaryIssuer)\", \"\(CredentialMocks.JwtCredentialEmailFromIdentityIssuer)\"]".toList() as! [String],
                finalizeOffersDescriptor: finalizeOffersDescriptorOfNotaryIssuer
            ) {
                do {
                    let verifiableCredentials = try $0.get()
                    assert(verifiableCredentials.passedCredentials.count == 1)
                    assert(
                        verifiableCredentials.passedCredentials.first {
                            $0.encodedJwt == CredentialMocks.JwtCredentialEmploymentPastFromNotaryIssuer
                        } != nil
                    )
                    
                    assert(verifiableCredentials.failedCredentials.count == 1)
                    assert(
                        verifiableCredentials.failedCredentials.first {
                            $0.encodedJwt == CredentialMocks.JwtCredentialEmailFromIdentityIssuer
                        } != nil
                    )
                } catch {
                    XCTFail("\(error)")
                }
            }
        }

        func testVerifyCredentialsEmpty() {
            subject.verifyCredentials(
                jwtEncodedCredentials: CredentialMocks.JwtEmptyCredentials.toList() as! [String],
                finalizeOffersDescriptor: finalizeOffersDescriptorOfNotaryIssuer
            ) {
                do {
                    let verifiableCredentials = try $0.get()
                    assert(verifiableCredentials.passedCredentials.isEmpty)
                    assert(verifiableCredentials.failedCredentials.isEmpty)
                } catch {
                    XCTFail("\(error)")
                }
            }
        }
}
