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
        guard let deepLinkDid = deepLink.did else {
            onError(
                errorMessage: "DID not found in deep link: \(deepLink.value)",
                completionBlock: completionBlock
            )
            return
        }

        if isDidBoundToDidDocument(
            presentationRequest.iss,
            didDocument: didDocument
        ) && isDidBoundToDidDocument(
            deepLinkDid,
            didDocument: didDocument
        ) {
            completionBlock(.success(true))
        } else {
            VCLLog.e("presentation request: \(presentationRequest.jwt.encodedJwt) \ndidDocument: \(didDocument)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)))
        }
    }

    private func isDidBoundToDidDocument(_ did: String, didDocument: VCLDidDocument) -> Bool {
        didDocument.id == did || didDocument.alsoKnownAs.contains(did)
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
