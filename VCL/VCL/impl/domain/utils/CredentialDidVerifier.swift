//
//  CredentialDidVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol CredentialDidVerifier {
    func verifyCredentials(
        jwtEncodedCredentials: [String],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    )
}
