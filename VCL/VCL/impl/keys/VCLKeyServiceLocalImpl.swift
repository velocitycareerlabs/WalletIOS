//
//  VCLKeyServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 11/05/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import CryptoKit
import Foundation
@preconcurrency import VCToken
@preconcurrency import VCCrypto

final class VCLKeyServiceLocalImpl: VCLKeyService {

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
        didJwkDescriptor: VCLDidJwkDescriptor = VCLDidJwkDescriptor(),
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        switch didJwkDescriptor.signatureAlgorithm {
        case .ES256:
            generateP256DidJwk(completionBlock: completionBlock)
        case .SECP256k1:
            generateSecp256k1DidJwk(completionBlock: completionBlock)
        }
    }
    
    func generateSecret(
        signatureAlgorithm: VCLSignatureAlgorithm = VCLSignatureAlgorithm.SECP256k1, // ignored
        completionBlock: @escaping (VCLResult<VCCrypto.VCCryptoSecret>) -> Void
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
            completionBlock(.failure(VCLError(message: "Invalid UUID format of keyID: \(keyId)")))
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

    /// Loads a P-256 private key saved by `generateDidJwk` for an ES256 descriptor.
    func retrieveP256PrivateKey(keyId: String) throws -> P256.Signing.PrivateKey {
        guard let id = UUID(uuidString: keyId) else {
            throw VCLError(message: "Invalid UUID format of keyID: \(keyId)")
        }
        return try P256.Signing.PrivateKey(rawRepresentation: keyManagementOperations.getKey(withId: id))
    }

    static func p256PublicJwk(publicKey: P256.Signing.PublicKey, keyId: String) throws -> ECPublicJwk {
        let coordinates = publicKey.rawRepresentation // x || y
        let jwk = [
            ECPublicJwk.CodingKeys.KeyType: "EC",
            ECPublicJwk.CodingKeys.KeyKeyId: keyId,
            ECPublicJwk.CodingKeys.KeyCurve: VCLSignatureAlgorithm.ES256.curve,
            ECPublicJwk.CodingKeys.KeyUse: "sig",
            ECPublicJwk.CodingKeys.KeyX: coordinates.prefix(32).base64URLEncodedString(),
            ECPublicJwk.CodingKeys.KeyY: coordinates.suffix(32).base64URLEncodedString()
        ]
        return try JSONDecoder().decode(ECPublicJwk.self, from: JSONSerialization.data(withJSONObject: jwk))
    }

    /// The private key is persisted through the same secret store as the secp256k1 secrets.
    private func generateP256DidJwk(completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void) {
        do {
            let privateKey = P256.Signing.PrivateKey()
            let keyId = UUID()
            try keyManagementOperations.save(key: privateKey.rawRepresentation, withId: keyId)
            completionBlock(.success(VCLKeyServiceLocalImpl.didJwk(
                publicJwk: try VCLKeyServiceLocalImpl.p256PublicJwk(publicKey: privateKey.publicKey, keyId: keyId.uuidString),
                keyId: keyId.uuidString
            )))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }

    private func generateSecp256k1DidJwk(completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void) {
        generateSecret { [weak self] secretResult in
            do {
                let secret = try secretResult.get()
                self?.retrievePublicJwk(secret: secret) { publicJwkResult in
                    do {
                        completionBlock(.success(VCLKeyServiceLocalImpl.didJwk(
                            publicJwk: try publicJwkResult.get(),
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

    /// Encodes the DID once and derives the kid from it: JSON key order is not stable between
    /// serializations, so encoding the JWK again for the kid can produce a different did:jwk string.
    private static func didJwk(publicJwk: ECPublicJwk, keyId: String) -> VCLDidJwk {
        let did = VCLDidJwk.generateDidJwk(publicKey: publicJwk)
        return VCLDidJwk(
            did: did,
            publicJwk: VCLPublicJwk(valueDict: publicJwk.toDictionary()),
            kid: "\(did)\(VCLDidJwk.DidJwkSuffix)",
            keyId: keyId
        )
    }
}
