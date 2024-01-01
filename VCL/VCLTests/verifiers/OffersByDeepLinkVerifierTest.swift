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
    private let subject = OffersByDeepLinkVerifierImpl()

    private let offersPayload = GenerateOffersMocks.RealOffers.toDictionary() ?? [:]
    private var offers: VCLOffers!
    private let correctDeepLink = DeepLinkMocks.CredentialManifestDeepLinkDevNet
    private let wrongDeepLink = VCLDeepLink(
        value: "velocity-network-devnet://issue?request_uri=https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbt%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition%26issuerDid%3Ddid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbt"
    )
    override func setUp() {
        offers = VCLOffers(
            payload: offersPayload,
            all: Utils.offersFromJsonArray(
                offersJsonArray: offersPayload[VCLOffers.CodingKeys.KeyOffers] as? [[String: Any]] ?? []
            ),
            responseCode: 0,
            sessionToken: VCLToken(value: ""),
            challenge: ""
        )
    }
    
    func verifyOffersSuccess() {
        subject.verifyOffers(
            offers: offers,
            deepLink: correctDeepLink
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
        subject.verifyOffers(
            offers: offers,
            deepLink: wrongDeepLink
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
