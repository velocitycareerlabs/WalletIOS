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
    "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xc257274276a4e539741ca11b590b9447b26a8051%2Foidc%26credential_type%3DPastEmploymentPosition%26pre-authorized_code%3D8L1UArquTYvE-ylC2BV_2%26issuerDid%3Ddid%3Avelocity%3A0xc257274276a4e539741ca11b590b9447b26a8051"
    
    static let IssuerDecoded =
    "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(OIDIssuerDid)/oidc?credential_type=PastEmploymentPosition&pre-authorized_code=8L1UArquTYvE-ylC2BV_2"
    static let OpenidInitiateIssuanceStrDev = "openid-initiate-issuance://?issuer=\(Issuer)"
    
    static let InspectorDid = "did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692"
    static let InspectorId = "987934576974554"
    
    static let PresentationRequestVendorOriginContext =
    "{\"SubjectKey\":{\"BusinessUnit\":\"ZC\",\"KeyCode\":\"54514480\"},\"Token\":\"832077a4\"}"
    
    static let PresentationRequestRequestDecodedUriStr =
    "https://agent.velocitycareerlabs.io/api/holder/v0.6/org/\(InspectorDid)/inspect/get-presentation-request?id=62e0e80c5ebfe73230b0becc&inspectorDid=\(InspectorDid)&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D".decode()
    static let PresentationRequestRequestDecodedUriWithIdStr =
    "https://agent.velocitycareerlabs.io/api/holder/v0.6/org/\(InspectorId)/inspect/get-presentation-request?id=62e0e80c5ebfe73230b0becc&inspectorDid=\(InspectorDid)&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22,%22KeyCode%22%3A%2254514480%22%7D,%22Token%22%3A%22832077a4%22%7D".decode()
    
    static let PresentationRequestRequestUriStr =
    "https%3A%2F%2Fagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Finspect%2Fget-presentation-request%3Fid%3D62e0e80c5ebfe73230b0becc%26inspectorDid%3Ddid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%26vendorOriginContext%3D%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22%2C%22KeyCode%22%3A%2254514480%22%7D%2C%22Token%22%3A%22832077a4%22%7D"
    static let PresentationRequestRequestUriWithIdStr =
        "https%3A%2F%2Fagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2F\(InspectorId)%2Finspect%2Fget-presentation-request%3Fid%3D62e0e80c5ebfe73230b0becc%26inspectorDid%3Ddid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%26vendorOriginContext%3D%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22%2C%22KeyCode%22%3A%2254514480%22%7D%2C%22Token%22%3A%22832077a4%22%7D"

    
    static let PresentationRequestDeepLinkDevNetStr =
    "\(DevNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkTestNetStr =
    "\(TestNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkMainNetStr =
    "\(MainNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriStr)"
    static let PresentationRequestDeepLinkMainNetWithIdStr =
        "\(MainNetProtocol)://inspect?request_uri=\(PresentationRequestRequestUriWithIdStr)"
    
    static let IssuerDid = "did:ion:EiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"
    static let IssuerId = "843794687t394524"
    
    static let CredentialManifestRequestDecodedUriStr =
    "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(IssuerDid)/issue/get-credential-manifest?id=611b5836e93d08000af6f1bc&credential_types=PastEmploymentPosition&issuerDid=\(IssuerDid)"
    static let CredentialManifestRequestDecodedUriWithIdStr =
    "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(IssuerId)/issue/get-credential-manifest?id=611b5836e93d08000af6f1bc&credential_types=PastEmploymentPosition&issuerDid=\(IssuerDid)"
    
    static let CredentialManifestRequestUriStr =
    "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition%26issuerDid%3Ddid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"
    static let CredentialManifestRequestUriWithIdStr =
        "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2F\(IssuerId)%2Fissue%2Fget-credential-manifest%3Fid%3D611b5836e93d08000af6f1bc%26credential_types%3DPastEmploymentPosition%26issuerDid%3Ddid%3Aion%3AEiApMLdMb4NPb8sae9-hXGHP79W1gisApVSE80USPEbtJA"
    
    
    static let CredentialManifestDeepLinkDevNetStr = "\(DevNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkTestNetStr = "\(TestNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkMainNetStr = "\(MainNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriStr)"
    static let CredentialManifestDeepLinkMainNetWithIdStr = "\(MainNetProtocol)://issue?request_uri=\(CredentialManifestRequestUriWithIdStr)"
    
    static let CredentialManifestDeepLinkDevNet = VCLDeepLink(value: CredentialManifestDeepLinkDevNetStr)
    static let CredentialManifestDeepLinkTestNet = VCLDeepLink(value: CredentialManifestDeepLinkTestNetStr)
    static let CredentialManifestDeepLinkMainNet = VCLDeepLink(value: CredentialManifestDeepLinkMainNetStr)
    static let CredentialManifestDeepLinkMainNetWithId = VCLDeepLink(value: CredentialManifestDeepLinkMainNetWithIdStr)

    static let PresentationRequestDeepLinkDevNet = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)
    static let PresentationRequestDeepLinkMainNetWithId = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkMainNetWithIdStr)

}
