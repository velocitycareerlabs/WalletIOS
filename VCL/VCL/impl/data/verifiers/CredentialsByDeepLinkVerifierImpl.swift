//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CredentialsByDeepLinkVerifierImpl: CredentialsByDeepLinkVerifier {
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        deepLink: VCLDeepLink,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let errorCredential = jwtCredentials.first(where: { $0.iss != deepLink.did }) {
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedCredentialIssuerDid.rawValue)))
        } else {
            completionBlock(.success(true))
        }
    }
}
