//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class PresentationRequestByDeepLinkVerifierImpl: PresentationRequestByDeepLinkVerifier {
    func verifyPresentationRequest(
        presentationRequest: VCLPresentationRequest,
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if presentationRequest.iss == deepLink.did {
            completionBlock(.success(true))
        } else {
            VCLLog.e("presentation request: \(presentationRequest.jwt.encodedJwt) \ndeepLink: \(deepLink.value)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)))
        }
    }
}
