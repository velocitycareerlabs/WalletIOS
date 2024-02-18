//
//  VCLKeyService.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

public protocol VCLKeyService {
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )
    func generateSecret(
        signatureAlgorithm: VCLSignatureAlgorithm,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    )
    func retrieveSecretReference(
        keyId: String,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    )
    func retrievePublicJwk(
        secret: VCCrypto.VCCryptoSecret,
        completionBlock: @escaping (VCLResult<VCToken.ECPublicJwk>) -> Void
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

    /// implemented for local crypto services only
    func generateSecret(
        signatureAlgorithm: VCLSignatureAlgorithm,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: "implemented for local crypto services only")))
    }
    /// implemented for local crypto services only
    func retrieveSecretReference(
        keyId: String,
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: "implemented for local crypto services only")))
    }
    /// implemented for local crypto services only
    func retrievePublicJwk(
        secret: VCCrypto.VCCryptoSecret,
        completionBlock: @escaping (VCLResult<VCToken.ECPublicJwk>) -> Void
    ) {
        completionBlock(.failure(VCLError(payload: "implemented for local crypto services only")))
    }
}
