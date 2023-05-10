//
//  JwtServiceImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class JwtServiceImpl: JwtService {
    
    private let secretStore: SecretStoring?
    
    init(secretStore: SecretStoring? = nil) {
        self.secretStore = secretStore
    }
    
    func decode(encodedJwt: String) -> VCLJwt {
        return VCLJwt(encodedJwt: encodedJwt)
    }

    func encode(jwt: String) -> VCLJwt {
        return VCLJwt(encodedJwt: "not implemented yet")
    }
    
    func verify(jwt: VCLJwt, jwkPublic: VCLJwkPublic) throws -> Bool {
        let pubKey = ECPublicJwk(
            x: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
            y: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
            keyId: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? ""
        )
        return try jwt.jwsToken?.verify(using: TokenVerifier(), withPublicKey: pubKey) == true
    }
    
    func sign(jwtDescriptor: VCLJwtDescriptor) throws -> VCLJwt {
        do {
            let secp256k1Signer = Secp256k1Signer()

            let privatePublicKeys = try getPrivatePublicKeys(
                keyId: jwtDescriptor.keyId,
                secp256k1Signer: secp256k1Signer,
                keyManagementOperations: createKeyManagementOperations()
            )
            
            let header = Header(
                type: GlobalConfig.TypeJwt,
                algorithm: GlobalConfig.AlgES256K,
                jsonWebKey: privatePublicKeys.publicKey// try publicKey.getThumbprint()
            )
            
            let payload = generatePayload(jwtDescriptor)
            
            let claims = VCLClaims(all: payload)
            
            let protectedMessage = try? createProtectedMessage(headers: header, claims: claims)
            guard let jwsToken = JwsToken(
                headers: header,
                content: claims,
                protectedMessage: protectedMessage
            ) else {
                throw VCLError(message: "Failed to create JwsToken")
            }
            
            let signature = try secp256k1Signer.sign(token: jwsToken, withSecret: privatePublicKeys.privateKey)
            guard let jwsTokenSigned = JwsToken(
                headers: jwsToken.headers,
                content: jwsToken.content,
                protectedMessage: jwsToken.protectedMessage,
                signature: signature,
                rawValue: jwsToken.rawValue
            ) else {
                throw VCLError(message: "Failed to create signed JwsToken")
            }
            return try VCLJwt(encodedJwt: jwsTokenSigned.serialize())
            
        } catch {
            throw VCLError(error: error)
        }
    }
    
    private func generatePayload(_ jwtDescriptor: VCLJwtDescriptor) -> [String: Any] {
        var retVal = jwtDescriptor.payload
        retVal["iss"] = jwtDescriptor.iss
        retVal["aud"] = jwtDescriptor.aud
        retVal["sub"] = randomString(length: 10)
        retVal["jti"] = jwtDescriptor.jti
        let date = Date()
        retVal["iat"] = date.toDouble()
        retVal["nbf"] = date.toDouble()
        retVal["exp"] = date.addDaysToNow(days: 7).toInt()
        return retVal
    }
    
    private func createProtectedMessage(headers: Header, claims: VCLClaims) throws -> String {
        let encoder = JSONEncoder()
        let encodedHeader = try encoder.encode(headers).base64URLEncodedString()
        if let encodedContent = claims.all.toJsonString()?.toData().base64URLEncodedString() {
            return encodedHeader  + "." + encodedContent
        } else {
            return encodedHeader
        }
    }
    
    func generateDidJwk() throws -> VCLDidJwk {
        let publicPrivateKeys = try generatePrivatePublicKeysSECP256K1(
            keyManagementOperations: createKeyManagementOperations(),
            secp256k1Signer: Secp256k1Signer()
        )
        return VCLDidJwk(
            keyId: publicPrivateKeys.privateKey.id.uuidString,
            didJwk: VCLDidJwk.generateDidJwk(publicKey: publicPrivateKeys.publicKey)
        )
    }
    
    private func getPrivatePublicKeys(
        keyId: String?,
        secp256k1Signer: Secp256k1Signer,
        keyManagementOperations: KeyManagementOperations
    ) throws -> (publicKey: ECPublicJwk, privateKey: VCCryptoSecret) {
        var privatePublicKeys: (publicKey: ECPublicJwk, privateKey: VCCryptoSecret)? = nil
        if let keyId = keyId {
            privatePublicKeys = try retrievePrivatePublicKeysSECP256K1(
                keyId: keyId,
                keyManagementOperations: keyManagementOperations,
                secp256k1Signer: secp256k1Signer
            )
        } else {
            privatePublicKeys = try generatePrivatePublicKeysSECP256K1(
                keyManagementOperations: keyManagementOperations,
                secp256k1Signer: secp256k1Signer
            )
        }
        guard let retVal = privatePublicKeys else {
            throw VCLError(payload: "Failed to get private/public keys!")
        }
        return retVal
    }
    
    private func generatePrivatePublicKeysSECP256K1(
        keyManagementOperations: KeyManagementOperations,
        secp256k1Signer: Secp256k1Signer
    ) throws -> (publicKey: ECPublicJwk, privateKey: VCCryptoSecret) {
        let privateKey = try keyManagementOperations.generateKey()
        let publicKey = try secp256k1Signer.getPublicJwk(from: privateKey, withKeyId: privateKey.id.uuidString)
        return (publicKey, privateKey)
    }
    
    private func retrievePrivatePublicKeysSECP256K1(
        keyId: String,
        keyManagementOperations: KeyManagementOperations,
        secp256k1Signer: Secp256k1Signer
    ) throws -> (publicKey: ECPublicJwk, privateKey: VCCryptoSecret) {
        if let keyUUID = UUID(uuidString: keyId) {
            let privateKey = keyManagementOperations.retrieveKeyFromStorage(withId: keyUUID)
            let publicKey = try secp256k1Signer.getPublicJwk(from: privateKey, withKeyId: privateKey.id.uuidString)
            return (publicKey, privateKey)
        }
        throw VCLError(payload: "Invalid UUID format of keyID: \(keyId)")
    }
    
    private func createKeyManagementOperations() -> KeyManagementOperations {
        var keyManagementOperations = KeyManagementOperations(
            sdkConfiguration: VCSDKConfiguration(
                accessGroupIdentifier: GlobalConfig.KeycahinAccessGroupIdentifier
            ))
        if let secretStore = self.secretStore {
            keyManagementOperations = KeyManagementOperations(
                secretStore: secretStore,
                sdkConfiguration: VCSDKConfiguration(
                    accessGroupIdentifier: GlobalConfig.KeycahinAccessGroupIdentifier
                ))
        }
        return keyManagementOperations
    }
}
