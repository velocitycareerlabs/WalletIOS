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
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let deepLinkDid = deepLink.did {
            if (didDocument.id == presentationRequest.iss && didDocument.id == deepLinkDid ||
                didDocument.alsoKnownAs.contains(presentationRequest.iss) && didDocument.alsoKnownAs.contains(deepLinkDid)) {
                completionBlock(.success(true))
            } else {
                VCLLog.e("presentation request: \(presentationRequest.jwt.encodedJwt) \ndidDocument: \(didDocument)")
                completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)))
            }
        } else {
            onError(
                errorMessage: "DID not found in deep link: \(deepLink.value)",
                completionBlock: completionBlock
            )
        }
    }
    
    private func onError(
        errorCode: VCLErrorCode = VCLErrorCode.SdkError,
        errorMessage: String,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        VCLLog.e(errorMessage)
        completionBlock(
            (VCLResult.failure(VCLError(errorCode: errorCode.rawValue, message: errorMessage)))
        )
    }
}
