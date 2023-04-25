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

/// TODO: Need to mock MS lib storage
class VCLFinalizeOffersDescriptorTest: XCTestCase {
    
    var credentialManifest: VCLCredentialManifest!
    
    var subject: VCLFinalizeOffersDescriptor!
    
    private let exchangeId = "exchangeId"
    private let finalizeOffersUri = "finalizeOffersUri"
    private let approvedOfferIds = ["approvedOfferId1", "approvedOfferId2"]
    private let rejectedOfferIds = ["rejectedOfferId1", "rejectedOfferId2"]
    
    override func setUp() {
//        let credentialManifest = VCLCredentialManifest(jwt: VCLJwt(encodedJwt: CredentialManifestMocks.CredentialManifestJwt))
//
//        subject = VCLFinalizeOffersDescriptor(
//            credentialManifest: credentialManifest,
//            approvedOfferIds: approvedOfferIds,
//            rejectedOfferIds: rejectedOfferIds
//        )
    }
    
    func testGenerateRequestBody() {
//        let uuid = UUID().uuidString
//        let jti = UUID().uuidString
//        let iss = UUID().uuidString
//        let aud = UUID().uuidString
//        let payload = "{\"key1\": \"value1\"}".toDictionary()!
//        var jwt: VCLJwt? = nil
//        do {
//            jwt = try JwtServiceImpl().sign(
//                jwtDescriptor: VCLJwtDescriptor(
//                    didJwk: JwtServiceMocks.didJwk,
//                    kid: uuid,
//                    payload: payload,
//                    jti: jti,
//                    iss: iss,
//                    aud: aud
//                ))
//        } catch {
//            XCTFail("\(error)")
//        }
//
//        let requestBody = subject.generateRequestBody(jwt: jwt!)
//
//        assert((requestBody["exchangeId"] as! String) == exchangeId)
//        assert((requestBody["approvedOfferIds"] as! String).toList() as! [String] == approvedOfferIds)
//        assert((requestBody["rejectedOfferIds"] as! String).toList() as! [String] == rejectedOfferIds)
//        let proof = (requestBody["proof"] as! String).toDictionary()!
//        assert((proof["proof_type"] as! String) == "jwt")
//        assert((proof["jwt"] as! String) == jwt?.encodedJwt)
    }
}
