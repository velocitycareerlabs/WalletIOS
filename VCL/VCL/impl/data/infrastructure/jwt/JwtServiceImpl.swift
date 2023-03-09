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
    
    func decode(encodedJwt: String) -> VCLJwt {
        return VCLJwt(encodedJwt: encodedJwt)
    }

    func encode(jwt: String) -> VCLJwt {
        return VCLJwt(encodedJwt: "not implemented yet")
    }
    
    func verify(jwt: VCLJwt, jwkPublic: VCLJwkPublic) throws -> Bool {
        let pubKey = ECPublicJwk(x: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
                                 y: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
                                 keyId: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? "")

        return try jwt.jwsToken?.verify(using: Secp256k1Verifier(), withPublicKey: pubKey) == true
    }
    
    func sign(jwtDescriptor: VCLJwtDescriptor) throws -> VCLJwt {
        do {
            let privatePublicKeys = try generateJwkSECP256K1FromKid(kid: jwtDescriptor.kid)
            let secp256k1Signer = Secp256k1Signer()
            let secret = jwtDescriptor.didJwk?.privateKey ?? privatePublicKeys.privateKey
            let publicKey = jwtDescriptor.didJwk?.publicKey ?? privatePublicKeys.publicKey
            
            let header = Header(type: GlobalConfig.TypeJwt,
                                algorithm: GlobalConfig.AlgES256K,
                                jsonWebKey: publicKey, // try publicKey.getThumbprint(),
                                keyId: jwtDescriptor.kid)
            
            let payload = generatePayload(jwtDescriptor)
            
            let claims = VCLClaims(all: payload)
            
            let protectedMessage = try? createProtectedMessage(headers: header, claims: claims)
            guard let jwsToken = JwsToken(headers: header,
                                          content: claims,
                                          protectedMessage: protectedMessage) else {
                throw VCLError(description: "Failed to create JwsToken")
            }
            
            let signature = try secp256k1Signer.sign(token: jwsToken, withSecret: secret)
            guard let jwsTokenSigned = JwsToken(headers: jwsToken.headers,
                                                content: jwsToken.content,
                                                protectedMessage: jwsToken.protectedMessage,
                                                signature: signature,
                                                rawValue: jwsToken.rawValue) else {
                throw VCLError(description: "Failed to create signed JwsToken")
            }
            return try VCLJwt(encodedJwt: jwsTokenSigned.serialize())
            
        } catch {
            throw VCLError(error: error)
        }
    }
    
    private func generatePayload(_ jwtDescriptor: VCLJwtDescriptor) -> [String: Any] {
        var retVal = jwtDescriptor.payload ?? [String: Any]()
        retVal["iss"] = jwtDescriptor.iss
        retVal["aud"] = jwtDescriptor.aud
        retVal["sub"] = randomString(length: 10)
        retVal["jti"] = jwtDescriptor.jti
        let date = Date()
        retVal["iat"] = date.toDouble()
        retVal["nbf"] = date.toDouble()
        retVal["exp"] = date.addDaysToNow(days: 7).toDouble()
        retVal["nonce"] = jwtDescriptor.nonce ?? ""
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
    
    func generateDidJwk(jwkDescriptor: VCLDidJwkDescriptor) throws -> VCLDidJwk {
        let publicPrivateKeys = try generateJwkSECP256K1FromKid(kid: jwkDescriptor.kid)
        return VCLDidJwk(
            publicKey: publicPrivateKeys.publicKey,
            privateKey: publicPrivateKeys.privateKey
        )
    }
    
    private func generateJwkSECP256K1FromKid(kid: String) throws -> (publicKey: ECPublicJwk, privateKey: VCCryptoSecret) {
        let secp256k1Signer = Secp256k1Signer()
        let secret = try CryptoOperations().generateKey()
        let publicKey = try secp256k1Signer.getPublicJwk(from: secret, withKeyId: kid)
        
        let pubKey = ECPublicJwk(x: publicKey.x, y: publicKey.y, keyId: kid)
        
        return (pubKey, secret)
    }
}
