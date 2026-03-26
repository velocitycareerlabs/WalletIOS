//
//  VCLSubmissionTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 11/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLSubmissionTest: XCTestCase {
    private var subjectPresentationSubmission: VCLSubmission!
    private var subjectIdentificationSubmission: VCLSubmission!
    private var credentialManifest: VCLCredentialManifest!
    
    private let issuingIss = "issuing iss"
    private let inspectionIss = "inspection iss"

    override func setUp() {
        subjectPresentationSubmission = VCLPresentationSubmission(
            presentationRequest: PresentationSubmissionMocks.PresentationRequest,
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList
        )
        
        credentialManifest = VCLCredentialManifest(
            jwt: CommonMocks.JWT,
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!),
            didJwk: DidJwkMocks.DidJwk
        )

        subjectIdentificationSubmission = VCLIdentificationSubmission(
            credentialManifest: credentialManifest,
            verifiableCredentials: PresentationSubmissionMocks.SelectionsList
        )
    }

    private func expectedPayload(
        iss: String,
        presentationDefinitionId: String,
        vendorOriginContext: String?
    ) -> [String: Any] {
        var vp = [String: Any]()
        vp[SubmissionCodingKeys.KeyContext] = SubmissionCodingKeys.ValueContextList
        vp[SubmissionCodingKeys.KeyType] = SubmissionCodingKeys.ValueVerifiablePresentation
        vp[SubmissionCodingKeys.KeyPresentationSubmission] = [
            SubmissionCodingKeys.KeyId: "<uuid>",
            SubmissionCodingKeys.KeyDefinitionId: presentationDefinitionId,
            SubmissionCodingKeys.KeyDescriptorMap: PresentationSubmissionMocks.SelectionsList.enumerated().map { index, credential in
                [
                    SubmissionCodingKeys.KeyId: credential.inputDescriptor,
                    SubmissionCodingKeys.KeyPath: "$.verifiableCredential[\(index)]",
                    SubmissionCodingKeys.KeyFormat: SubmissionCodingKeys.ValueJwtVcFormat
                ]
            }
        ]
        vp[SubmissionCodingKeys.KeyVerifiableCredential] =
            PresentationSubmissionMocks.SelectionsList.map { $0.jwtVc }
        if let vendorOriginContext {
            vp[SubmissionCodingKeys.KeyVendorOriginContext] = vendorOriginContext
        }

        return [
            SubmissionCodingKeys.KeyJti: "<uuid>",
            SubmissionCodingKeys.KeyIss: iss,
            SubmissionCodingKeys.KeyVp: vp
        ]
    }

    private func normalizedPayload(_ payload: [String: Any]) -> [String: Any] {
        var normalizedPayload = payload

        guard let jti = payload[SubmissionCodingKeys.KeyJti] as? String else {
            XCTFail("Missing jti in submission payload")
            return normalizedPayload
        }
        XCTAssertNotNil(UUID(uuidString: jti))
        normalizedPayload[SubmissionCodingKeys.KeyJti] = "<uuid>"

        guard
            var vp = payload[SubmissionCodingKeys.KeyVp] as? [String: Any],
            var presentationSubmission =
                vp[SubmissionCodingKeys.KeyPresentationSubmission] as? [String: Any],
            let submissionId = presentationSubmission[SubmissionCodingKeys.KeyId] as? String
        else {
            XCTFail("Missing presentation submission id in payload")
            return normalizedPayload
        }

        XCTAssertNotNil(UUID(uuidString: submissionId))
        presentationSubmission[SubmissionCodingKeys.KeyId] = "<uuid>"
        vp[SubmissionCodingKeys.KeyPresentationSubmission] = presentationSubmission
        normalizedPayload[SubmissionCodingKeys.KeyVp] = vp

        return normalizedPayload
    }

    func testPayload() {
        let presentationSubmissionPayload = subjectPresentationSubmission.generatePayload(iss: inspectionIss)
        XCTAssertEqual(
            normalizedPayload(presentationSubmissionPayload) as NSDictionary,
            expectedPayload(
                iss: inspectionIss,
                presentationDefinitionId:
                    PresentationSubmissionMocks.PresentationRequest.presentationDefinitionId,
                vendorOriginContext:
                    PresentationSubmissionMocks.PresentationRequest.vendorOriginContext
            ) as NSDictionary
        )

        let identificationSubmissionPayload = subjectIdentificationSubmission.generatePayload(iss: issuingIss)
        XCTAssertEqual(
            normalizedPayload(identificationSubmissionPayload) as NSDictionary,
            expectedPayload(
                iss: issuingIss,
                presentationDefinitionId: credentialManifest.presentationDefinitionId,
                vendorOriginContext: credentialManifest.vendorOriginContext
            ) as NSDictionary
        )
    }

    func testRequestBody() {
        let requestBodyJsonObj = subjectPresentationSubmission.generateRequestBody(jwt: JwtServiceMocks.JWT)
        XCTAssertEqual(
            requestBodyJsonObj as NSDictionary,
            [
                SubmissionCodingKeys.KeyExchangeId:
                    PresentationSubmissionMocks.PresentationRequest.exchangeId,
                SubmissionCodingKeys.KeyJwtVp: JwtServiceMocks.JWT.encodedJwt,
                SubmissionCodingKeys.KeyPushDelegate: [
                    VCLPushDelegate.CodingKeys.KeyPushUrl: PresentationSubmissionMocks.PushDelegate.pushUrl,
                    VCLPushDelegate.CodingKeys.KeyPushToken: PresentationSubmissionMocks.PushDelegate.pushToken
                ]
            ] as NSDictionary
        )
    }
    
    func testContext() {
        XCTAssertEqual(SubmissionCodingKeys.KeyContext, "@context")
        XCTAssertEqual(SubmissionCodingKeys.ValueContextList, ["https://www.w3.org/2018/credentials/v1"])
    }
}
