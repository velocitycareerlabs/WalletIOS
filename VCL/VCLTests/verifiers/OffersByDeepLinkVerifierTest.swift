//
//  OffersByDeepLinkVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class OffersByDeepLinkVerifierTest: XCTestCase {
    private var subject: OffersByDeepLinkVerifier!
    
    private let offersPayload = GenerateOffersMocks.RealOffers.toDictionary() ?? [:]
    private var offers: VCLOffers!
    private let deepLink = DeepLinkMocks.CredentialManifestDeepLinkDevNet

    override func setUp() {
        offers = VCLOffers(
            payload: offersPayload,
            all: VerificationUtils.offersFromJsonArray(
                offersJsonArray: offersPayload[VCLOffers.CodingKeys.KeyOffers] as? [[String: Any]] ?? []
            ),
            responseCode: 0,
            sessionToken: VCLToken(value: ""),
            challenge: ""
        )
    }
    
    func verifyOffersSuccess() {
        subject = OffersByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentMockStr)
            )
        )
        
        subject.verifyOffers(
            offers: offers,
            deepLink: deepLink
        ) { isVerifiedRes in
            do {
                let isVerified = try isVerifiedRes.get()
                assert(isVerified)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func verifyOffersError() {
        subject = OffersByDeepLinkVerifierImpl(
            ResolveDidDocumentRepositoryImpl(
                NetworkServiceSuccess(validResponse: DidDocumentMocks.DidDocumentWithWrongDidMockStr)
            )
        )
        
        subject.verifyOffers(
            offers: offers,
            deepLink: deepLink
        ) { isVerifiedRes in
            do {
                _ = try isVerifiedRes.get()
                XCTFail("\(VCLErrorCode.MismatchedOfferIssuerDid.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.MismatchedOfferIssuerDid.rawValue)
            }
        }
    }
}
