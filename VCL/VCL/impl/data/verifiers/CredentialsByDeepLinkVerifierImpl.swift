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
        if let mismatchedCredential = jwtCredentials.first(where: { $0.iss != deepLink.did }) {
            VCLLog.e("mismatched credential: \(mismatchedCredential.encodedJwt) \ndeepLink: \(deepLink.value)")
            completionBlock(.failure(VCLError(errorCode: VCLErrorCode.MismatchedCredentialIssuerDid.rawValue)))
        } else {
            completionBlock(.success(true))
        }
    }
}
