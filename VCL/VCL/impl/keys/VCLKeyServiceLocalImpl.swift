//
//  VCLKeyServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class VCLKeyServiceLocalImpl: VCLKeyService {

    private let secretStore: SecretStoring?
    private let tokenSigning: TokenSigning
    private let keyManagementOperations: KeyManagementOperations

    init(
        secretStore: SecretStoring? = nil
    ) {
        self.secretStore = secretStore
        self.tokenSigning = Secp256k1Signer() // No need to be injected
        self.keyManagementOperations = VCLKeyServiceLocalImpl.createKeyManagementOperations(secretStore: secretStore)
    }

    func generateDidJwk(
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        generateSecret { [weak self] secretResult in
            do {
                let secret = try secretResult.get()
                self?.retrievePublicJwk(secret: secret) { publicJwkResult in
                    do {
                        let publicJwk = try publicJwkResult.get()
                        completionBlock(.success(VCLDidJwk(
                            did: VCLDidJwk.generateDidJwk(publicKey: publicJwk),
                            publicJwk: VCLPublicJwk(valueDict: publicJwk.toDictionary()),
                            kid: VCLDidJwk.generateKidFromDidJwk(publicKey: publicJwk),
                            keyId: secret.id.uuidString
                        )))
                    } catch {
                        completionBlock(.failure(VCLError(error: error)))
                    }
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func generateSecret(
        completionBlock: @escaping (VCLResult<VCCryptoSecret>) -> Void
    ) {
        do {
            completionBlock(.success(try keyManagementOperations.generateKey()))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
    
    func retrieveSecretReference(
        keyId: String,
        completionBlock: @escaping (VCLResult<VCCryptoSecret>) -> Void
    ) {
        if let keyId = UUID(uuidString: keyId) {
            completionBlock(.success(keyManagementOperations.retrieveKeyFromStorage(withId: keyId)))
        } else {
            completionBlock(.failure(VCLError(payload: "Invalid UUID format of keyID: \(keyId)")))
        }
    }
    
    func retrievePublicJwk(
        secret: VCCryptoSecret,
        completionBlock: @escaping (VCLResult<ECPublicJwk>) -> Void
    ) {
        do {
            completionBlock(.success(try tokenSigning.getPublicJwk(from: secret, withKeyId: secret.id.uuidString)))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
