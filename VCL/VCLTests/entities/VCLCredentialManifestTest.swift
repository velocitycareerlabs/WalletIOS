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

/// TODO: Need to mock MS lib storage
class VCLCredentialManifestTest: XCTestCase {
    var subject: VCLCredentialManifest!

    override func setUp() {
//        do {
//            subject = try VCLCredentialManifest(
//                jwt: JwtServiceImpl(secretStore: SecretStoreMock()).sign(
//                    jwtDescriptor: VCLJwtDescriptor(
//                        payload: CredentialManifestMocks.Payload,
//                        iss: "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw"
//                    )
//                )
//            )
//        } catch {
//            XCTFail("\(error)")
//        }
    }
    func testProps() {
//        assert(subject.iss == "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw")
//        assert(subject.did == "did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw")
//        assert(subject.issuerId == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw")
//        assert(subject.exchangeId == "64006b95e348b5f886942e31")
//        assert(subject.presentationDefinitionId == "64006b95e348b5f886942e31.621c9beec8fa34b8e72d5fc7")
//        assert(subject.finalizeOffersUri == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw/issue/finalize-offers")
//        assert(subject.checkOffersUri == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw/issue/credential-offers")
//        assert(subject.submitPresentationUri == "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:ion:EiAbP9xvCYnUOiLwqgbkV4auH_26Pv7BT2pYYT3masvvhw/issue/submit-identification")
    }
}
