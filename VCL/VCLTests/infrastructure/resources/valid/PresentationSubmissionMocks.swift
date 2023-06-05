//
//  PresentationSubmissionMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class PresentationSubmissionMocks {
    static let PushDelegate = VCLPushDelegate(
        pushUrl: "https://devservices.velocitycareerlabs.io/api/push-gateway",
        pushToken: "if0123asd129smw321"
    )
    static let PresentationSubmissionResultJson = "{\"token\":\"u7yLD8KS2eTEqkg9aRQE\",\"exchange\":{\"id\":\"64131231\",\"type\":\"DISCLOSURE\",\"disclosureComplete\":true,\"exchangeComplete\":true}}"
    static let PresentationRequest = VCLPresentationRequest(
        jwt: JwtServiceMocks.JWT,
        jwkPublic: JwtServiceMocks.JwkPublic,
        deepLink: DeepLinkMocks.CredentialManifestDeepLinkMainNet,
        pushDelegate: PushDelegate
    )

    static let SelectionsList = [
        VCLVerifiableCredential(inputDescriptor: "PhoneV1.0", jwtVc: JwtServiceMocks.AdamSmithPhoneJwt),
        VCLVerifiableCredential(inputDescriptor: "EmailV1.0", jwtVc: JwtServiceMocks.AdamSmithEmailJwt)
    ]
    
    static let PresentationSubmissionJwt = PresentationRequestMocks.PresentationRequestJwt
}
