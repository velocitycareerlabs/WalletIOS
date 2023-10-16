//
//  VCLFinalizeOffersDescriptorTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 06/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLFinalizeOffersDescriptorTest: XCTestCase {
    
    var subject: VCLFinalizeOffersDescriptor!
    
    private let offers = VCLOffers(
        payload: [String: Any](),
        all: [[String: Any]](),
        responseCode: 200,
        sessionToken: VCLToken(value: ""),
        challenge: ""
    )
    
    private let jtiMock = "some jti"
    private let issMock = "some iss"
    private let audMock = "some sud"
    private let nonceMock = "some nonce"
    
    private let approvedOfferIds = ["approvedOfferId1", "approvedOfferId2"]
    private let rejectedOfferIds = ["rejectedOfferId1", "rejectedOfferId2"]
    
    override func setUp() {
        
        let credentialManifest = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifest1),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!)
        )
        
        subject = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifest,
            offers: offers,
            approvedOfferIds: approvedOfferIds,
            rejectedOfferIds: rejectedOfferIds
        )
    }
    
    func testGenerateRequestBody() {
        let payload = "{\"key1\": \"value1\"}".toDictionary()!
        
        VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)).sign(
            nonce: nonceMock,
            jwtDescriptor: VCLJwtDescriptor(
                payload: payload,
                jti: jtiMock,
                iss: issMock,
                aud: audMock
            )) { [weak self] jwtResult in
                do {
                    let jwt = try jwtResult.get()
                    let requestBody = self!.subject.generateRequestBody(jwt: jwt)
                    
                    assert((requestBody["exchangeId"] as! String) == "645e315309237c760ac022b1")
                    assert(requestBody["approvedOfferIds"] as? [String] == self!.approvedOfferIds)
                    assert(requestBody["rejectedOfferIds"] as? [String] == self!.rejectedOfferIds)
                    
                    let proof = requestBody["proof"] as? [String: Any]
                    assert((proof?["proof_type"] as? String) == "jwt")
                    assert((proof?["jwt"] as? String) == jwt.encodedJwt)
                    //        equivalent to checking nonce in proof jwt
                    assert(jwt.payload?["nonce"] as? String == self!.nonceMock)
                } catch {
                    XCTFail("\(error)")
                }
            }
    }
}
