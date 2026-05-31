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
        completionBlock: @escaping (VCLResult<Void>) -> Void
    ) {
        if isDidBoundToDidDocument(
            presentationRequest.iss,
            didDocument: didDocument
        ) && isDidBoundToDidDocument(
            deepLink.did ?? "",
            didDocument: didDocument
        ) {
            completionBlock(.success(()))
        } else {
            VCLLog.e("presentation request: \(presentationRequest.jwt.encodedJwt) \ndidDocument: \(didDocument)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue)))
        }
    }

    private func isDidBoundToDidDocument(_ did: String, didDocument: VCLDidDocument) -> Bool {
        didDocument.id == did || didDocument.alsoKnownAs.contains(did)
    }
}
