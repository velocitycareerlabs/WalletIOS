//
//  CredentialIssuerVerifierEmptyImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialIssuerVerifierEmptyImpl: CredentialIssuerVerifier {
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        VCLLog.d("Empty implementation - credential issuer is always approved...")
        completionBlock(.success(true))
    }
}
