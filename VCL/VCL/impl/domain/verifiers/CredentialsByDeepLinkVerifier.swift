//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialsByDeepLinkVerifier: Sendable {
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        deepLink: VCLDeepLink,
        completionBlock: @escaping @Sendable (VCLResult<Bool>) -> Void
    )
}
