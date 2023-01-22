//
//  VCLCredentialManifestDescriptorMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class CredentialManifestDescriptorMocks {
    
    static let DeepLink = DeepLinkMocks.CredentialManifestDeepLinkMainNet
    static let IssuerDid = DeepLinkMocks.IssuerDid

    static let DeepLinkRequestUri = DeepLinkMocks.CredentialManifestRequestUriStr

    static let CredentialTypesList = ["PastEmploymentPosition", "CurrentEmploymentPosition"]

    static let PushDelegate = VCLPushDelegate(
        pushUrl: "https://devservices.velocitycareerlabs.io/api/push-gateway",
        pushToken: "if0123asd129smw321"
    )

    static let IssuingServiceEndPoint =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(IssuerDid)/issue/get-credential-manifest"

    static let IssuingServiceJsonStr =
        "{\"id\":\"\(IssuerDid)#credential-agent-issuer-1\",\"type\":\"VelocityCredentialAgentIssuer_v1.0\",\"credentialTypes\":[\"Course\",\"EducationDegree\",\"Badge\"],\"serviceEndpoint\":\"\(IssuingServiceEndPoint)\"}"

    static let IssuingServiceWithParamEndPoint =
        "https://devagent.velocitycareerlabs.io/api/holder/v0.6/org/\(IssuerDid)/issue/get-credential-manifest?key=value"

    static let IssuingServiceWithParamJsonStr =
        "{\"id\":\"\(IssuerDid)#credential-agent-issuer-1\",\"type\":\"VelocityCredentialAgentIssuer_v1.0\",\"credentialTypes\":[\"Course\",\"EducationDegree\",\"Badge\"],\"serviceEndpoint\":\"\(IssuingServiceWithParamEndPoint)\"}"

    static let CredentialId1 = "did:velocity:v2:0x2bef092530ccc122f5fe439b78eddf6010685e88:248532930732481:1963"
    static let CredentialId2 = "did:velocity:v2:0x2bef092530ccc122f5fe439b78eddf6010685e88:248532930732481:1963"
}

