//
//  KeyService.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

protocol KeyService {
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    )
    func generateSecret(
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

extension KeyService {
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
}
