//
//  PresentationSubmissionMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/05/2021.
//

import Foundation
@testable import VCL

class PresentationSubmissionMocks {
    static let PresentationSubmissionResultJson = "{\"token\":\"u7yLD8KS2eTEqkg9aRQE\",\"exchange\":{\"id\":\"64131231\",\"type\":\"DISCLOSURE\",\"disclosureComplete\":true,\"exchangeComplete\":true}}"
    static let PresentationRequest = VCLPresentationRequest(
        jwt: JwtServiceMocks.JWT,
        publicKey: JwtServiceMocks.PublicKey,
        deepLink: DeepLinkMocks.PresentationRequestDeepLink
    )

    static let SelectionsList = [
        VCLVerifiableCredential(inputDescriptor: "IdDocument", jwtVc: JwtServiceMocks.AdamSmithIdDocumentJwt),
        VCLVerifiableCredential(inputDescriptor: "Email", jwtVc: JwtServiceMocks.AdamSmithEmailJwt)
    ]
    
    static let PresentationSubmissionJwt = PresentationRequestMocks.PresentationRequestJwt
}
