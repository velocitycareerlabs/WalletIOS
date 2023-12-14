//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialManifestByDeepLinkVerifierImpl: CredentialManifestByDeepLinkVerifier {
    func verifyCredentialManifest(
        credentialManifest: VCLCredentialManifest,
        deepLink: VCLDeepLink, 
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if credentialManifest.issuerId == deepLink.did {
            completionBlock(.success(true))
        } else {
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedRequestIssuerDid.rawValue)))
        }
    }
}

