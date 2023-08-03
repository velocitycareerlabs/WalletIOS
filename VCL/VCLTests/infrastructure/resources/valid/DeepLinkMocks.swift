//
//  VCLDeepLinkMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class DeepLinkMocks {
    
    private static let DevNetProtocol = "velocity-network-devnet"
    private static let TestNetProtocol = "velocity-network-testnet"
    private static let MainNetProtocol = "velocity-network"

    static let OIDIssuerDid = "did:velocity:0xc257274276a4e539741ca11b590b9447b26a8051"

    static let Issuer =
        "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xc257274276a4e539741ca11b590b9447b26a8051%2Foidc%26credential_type%3DPastEmploymentPosition%26pre-authorized_code%3D8L1UArquTYvE-ylC2BV_2"
    static let IssuerDecoded =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(OIDIssuerDid)/oidc?credential_type=PastEmploymentPosition&pre-authorized_code=8L1UArquTYvE-ylC2BV_2"
    static let OpenidInitiateIssuanceStrDev = "openid-initiate-issuance://?issuer=\(Issuer)"

    static let InspectorDid = "did:ion:EiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA"

    static let PresentationRequestVendorOriginContext =
        "{\"SubjectKey\":{\"BusinessUnit\":\"ZC\",\"KeyCode\":\"54514480\"},\"Token\":\"832077a4\"}"

    static let PresentationRequestRequestDecodedUriStr =
        "https://agent.velocitycareerlabs.io/api/holder/v0.6/org/\(InspectorDid)/inspect/get-presentation-request?id=62e0e80c5ebfe73230b0becc&inspectorDid=\(InspectorDid.encode() ?? "")&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D".decode()

    static let PresentationRequestRequestUriStr =
        "https%3A%2F%2Fagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA%2Finspect%2Fget-presentation-request%3Fid%3D62e0e80c5ebfe73230b0becc&inspectorDid=did%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D"

    static let PresentationRequestDeepLinkDevNetStr =
        "\(DevNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkTestNetStr =
        "\(TestNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkMainNetStr =
        "\(MainNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"

    static let IssuerDid = "did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692"

    static let CredentialManifestRequestDecodedUriStr =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(IssuerDid)/issue/get-credential-manifest?id=611b5836e93d08000af6f1bc&credential_types=PastEmploymentPosition"

    static let CredentialManifestRequestUriStr =
        "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition"

    static let CredentialManifestDeepLinkDevNetStr = "\(DevNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkTestNetStr = "\(TestNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkMainNetStr = "\(MainNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"

    static let CredentialManifestDeepLinkDevNet = VCLDeepLink(value: CredentialManifestDeepLinkDevNetStr)
    static let CredentialManifestDeepLinkTestNet = VCLDeepLink(value: CredentialManifestDeepLinkTestNetStr)
    static let CredentialManifestDeepLinkMainNet = VCLDeepLink(value: CredentialManifestDeepLinkMainNetStr)

    static let PresentationRequestDeepLinkDevNet = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)
}
