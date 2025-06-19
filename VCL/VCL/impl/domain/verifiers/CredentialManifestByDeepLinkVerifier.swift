//
//  CredentialIssuerVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 12/12/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialManifestByDeepLinkVerifier {
    func verifyCredentialManifest(
        credentialManifest: VCLCredentialManifest,
        deepLink: VCLDeepLink,
        didDocument: VCLDidDocument,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
}
