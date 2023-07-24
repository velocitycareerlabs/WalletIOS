//
//  VCLCredentialManifestTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 06/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VCLCredentialManifestTest: XCTestCase {
    var subject: VCLCredentialManifest!

    override func setUp() {
        subject = VCLCredentialManifest(
            jwt: VCLJwt(encodedJwt: CredentialManifestMocks.JwtCredentialManifest1),
            verifiedProfile: VCLVerifiedProfile(payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!)
        )
    }
                                        
    func testProps() {
        assert(subject.iss == "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA")
        assert(subject.did == "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA")
        assert(subject.issuerId == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA")
        assert(subject.exchangeId == "645e315309237c760ac022b1")
        assert(subject.presentationDefinitionId == "645e315309237c760ac022b1.6384a3ad148b1991687f67c9")
        assert(subject.finalizeOffersUri == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/finalize-offers")
        assert(subject.checkOffersUri == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/credential-offers")
        assert(subject.submitPresentationUri == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA/issue/submit-identification")
    }
}
