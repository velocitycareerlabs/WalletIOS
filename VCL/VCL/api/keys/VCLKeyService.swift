//
//  VCLKeyService.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@preconcurrency import VCToken
@preconcurrency import VCCrypto

public protocol VCLKeyService {
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )
}

extension VCLKeyService {
    static func createKeyManagementOperations(secretStore: SecretStoring? = nil) -> KeyManagementOperations {
        var keyManagementOperations = KeyManagementOperations(
            sdkConfiguration: VCSDKConfiguration(
                accessGroupIdentifier: GlobalConfig.KeycahinAccessGroupIdentifier
            ))
        if let secretStore = secretStore {
            keyManagementOperations = KeyManagementOperations(
                secretStore: secretStore,
                sdkConfiguration: VCSDKConfiguration(
                    accessGroupIdentifier: GlobalConfig.KeycahinAccessGroupIdentifier
                ))
        }
        return keyManagementOperations
    }

//===========================================================================================================================

//    "⚠️" NOTE:
//    The whole below methods cannot be part of the public API, since the MS Crypto data structure dausen't conform Sendable
    
    /// implemented for local crypto services only
//    func generateSecret(
//        signatureAlgorithm: VCLSignatureAlgorithm,
//        completionBlock: @escaping @Sendable (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
//    ) {
//        completionBlock(.failure(VCLError(payload: "implemented for local crypto services only")))
//    }
    
    /// implemented for local crypto services only
//    func retrieveSecretReference(
//        keyId: String,
//        completionBlock: @escaping @Sendable (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
//    ) {
//        completionBlock(.failure(VCLError(payload: "implemented for local crypto services only")))
//    }
    
    /// implemented for local crypto services only
//    func retrievePublicJwk(
//        secret: VCCrypto.VCCryptoSecret,
//        completionBlock: @escaping @Sendable (VCLResult<VCToken.ECPublicJwk>) -> Void
//    ) {
//        completionBlock(.failure(VCLError(payload: "implemented for local crypto services only")))
//    }

//===========================================================================================================================
}
