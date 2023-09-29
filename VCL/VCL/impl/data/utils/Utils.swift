//
//  Utils.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class Utils {
    static func getCredentialType(_ jwtCredential: VCLJwt) -> String? {
        return ((jwtCredential.payload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: Any])?[CredentialIssuerVerifierImpl.CodingKeys.KeyType] as? [String])?.first
    }
    
    static func getCredentialSubject(_ jwtCredential: VCLJwt) -> [String: Any]? {
        return ((jwtCredential.payload?[CredentialIssuerVerifierImpl.CodingKeys.KeyVC] as? [String: Any])?[CredentialIssuerVerifierImpl.CodingKeys.KeyCredentialSubject] as? [String: Any])
    }
}
