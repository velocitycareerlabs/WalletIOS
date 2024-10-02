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
        completionBlock: @escaping @Sendable (VCLResult<Bool>) -> Void
    ) {
        if credentialManifest.issuerId == deepLink.did {
            completionBlock(.success(true))
        } else {
            VCLLog.e("credential manifest: \(credentialManifest.jwt.encodedJwt) \ndeepLink: \(deepLink.value)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedRequestIssuerDid.rawValue)))
        }
    }
}

