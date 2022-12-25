//
//  VCLDeepLinkMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class DeepLinkMocks {
    
    private static let DevNetProtocol = "velocity-network-devnet"
    private static let TestNetProtocol = "velocity-network-testnet"
    private static let MainNetProtocol = "velocity-network"

    static let InspectorDid = "did:ion:EiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA"

    static let PresentationRequestRequestDecodedUriStr =
        "https://stagingagent.velocitycareerlabs.io/api/holder/v0.6/org/\(InspectorDid)/inspect/get-presentation-request?id=62e0e80c5ebfe73230b0becc&inspectorDid=did%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D"

    static let PresentationRequestRequestUriStr =
        "https%3A%2F%2Fstagingagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA%2Finspect%2Fget-presentation-request%3Fid%3D62e0e80c5ebfe73230b0becc&inspectorDid=did%3Aion%3AEiByBvq95tfmhl41DOxJeaa26HjSxAUoz908PITFwMRDNA&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D"

    static let PresentationRequestDeepLinkDevNetStr =
        "\(DevNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkTestNetStr =
        "\(TestNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkMainNetStr =
        "\(MainNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"

    static let PresentationRequestVendorOriginContext =
        "{\"SubjectKey\":{\"BusinessUnit\":\"ZC\",\"KeyCode\":\"54514480\"},\"Token\":\"832077a4\"}"

    static let CredentialManifestRequestDecodedUriStr =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692/issue/get-credential-manifest?id=611b5836e93d08000af6f1bc&credential_types=PastEmploymentPosition"

    static let CredentialManifestRequestUriStr =
        "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition"

    static let CredentialManifestDeepLinkDevNetStr = "\(DevNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkTestNetStr = "\(TestNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkMainNetStr = "\(MainNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"

    public static let CredentialManifestDeepLinkDevNet = VCLDeepLink(value: CredentialManifestDeepLinkDevNetStr)
    public static let CredentialManifestDeepLinkTestNet = VCLDeepLink(value: CredentialManifestDeepLinkTestNetStr)
    public static let CredentialManifestDeepLinkMainNet = VCLDeepLink(value: CredentialManifestDeepLinkMainNetStr)
    
    public static let PresentationRequestDeepLinkDevNet = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)
}
