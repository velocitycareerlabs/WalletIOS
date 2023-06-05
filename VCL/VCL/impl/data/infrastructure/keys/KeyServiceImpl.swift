//
//  KeyServiceImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class KeyServiceImpl: KeyService {

    private let secretStore: SecretStoring?
    private let tokenSigning: TokenSigning
    private let keyManagementOperations: KeyManagementOperations

    init(
        secretStore: SecretStoring? = nil
    ) {
        self.secretStore = secretStore
        self.tokenSigning = Secp256k1Signer() // No need to be injected
        self.keyManagementOperations = KeyServiceImpl.createKeyManagementOperations(secretStore: secretStore)
    }

    func generateDidJwk() throws -> VCLDidJwk {
        let secret = try generateSecret()
        let publicJwk = try retrievePublicJwk(secret: secret)
        return VCLDidJwk(
            keyId: secret.id.uuidString,
            value: VCLDidJwk.generateDidJwk(publicKey: publicJwk),
            kid: VCLDidJwk.generateKidFromDidJwk(publicKey: publicJwk)
        )
    }
    
    func generateSecret() throws -> VCCryptoSecret {
        return try keyManagementOperations.generateKey()
    }
    
    func retrieveSecretReference(keyId: String) throws ->  VCCryptoSecret {
        if let keyId = UUID(uuidString: keyId) {
            return keyManagementOperations.retrieveKeyFromStorage(withId: keyId)
        }
        throw VCLError(payload: "Invalid UUID format of keyID: \(keyId)")
    }
    
    func retrievePublicJwk(secret: VCCryptoSecret) throws -> ECPublicJwk {
        return try tokenSigning.getPublicJwk(from: secret, withKeyId: secret.id.uuidString)
    }
}
