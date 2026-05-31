//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialManifestByDeepLinkVerifierImpl: CredentialManifestByDeepLinkVerifier {
    
    func verifyCredentialManifest(
        credentialManifest: VCLCredentialManifest,
        deepLink: VCLDeepLink,
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Void>) -> Void
    ) {
        if (didDocument.id == credentialManifest.iss && didDocument.id == deepLink.did ||
            didDocument.alsoKnownAs.contains(credentialManifest.iss) && didDocument.alsoKnownAs.contains(deepLink.did ?? "")) {
            completionBlock(.success(()))
        } else {
            onError(
                errorCode: VCLErrorCode.MismatchedRequestIssuerDid,
                errorMessage: "credential manifest: \(credentialManifest.jwt.encodedJwt) \ndidDocument: \(didDocument)",
                completionBlock: completionBlock
            )
        }
    }
    
    private func onError(
        errorCode: VCLErrorCode = VCLErrorCode.SdkError,
        errorMessage: String,
        completionBlock: @escaping (VCLResult<Void>) -> Void
    ) {
        VCLLog.e(errorMessage)
        completionBlock(
            (VCLResult.failure(VCLError(errorCode: errorCode.rawValue, message: errorMessage)))
        )
    }
}
