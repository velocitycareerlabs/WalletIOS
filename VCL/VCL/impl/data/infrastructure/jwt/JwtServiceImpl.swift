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
    func decode(
        encodedJwt: String,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        completionBlock(.success(VCLJwt(encodedJwt: encodedJwt)))
    }
    
    func encode(
        jwt: String,
        completionBlock: @escaping (VCLResult<String>) -> Void
    ) {
        completionBlock(.failure(VCLError(message: "Not implemented")))
    }
    
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        let pubKey = ECPublicJwk(x: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
                                 y: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
                                 keyId: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? "")
        do {
            let isVerified = try jwt.jwsToken?.verify(using: Secp256k1Verifier(), withPublicKey: pubKey) == true
            completionBlock(.success(isVerified))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
    
    func sign(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        do {
            let keyId = UUID().uuidString
            let secp256k1Signer = Secp256k1Signer()
            let secret = try CryptoOperations().generateKey()
            let publicKey = try secp256k1Signer.getPublicJwk(from: secret, withKeyId: keyId)
            
            let header = Header(type: GlobalConfig.TypeJwt,
                                algorithm: GlobalConfig.AlgES256K,
                                jsonWebKey: publicKey, // try publicKey.getThumbprint(),
                                keyId: keyId)
            
            let payload = generatePayload(jwtDescriptor)
            
            let claims = VCLClaims(all: payload)
            let protectedMessage = try? createProtectedMessage(headers: header, claims: claims)
            guard let jwsToken = JwsToken(headers: header,
                                          content: claims,
                                          protectedMessage: protectedMessage) else {
                completionBlock(.failure(VCLError(message: "Failed to create JwsToken")))
                return
            }
            
            let signature = try secp256k1Signer.sign(token: jwsToken, withSecret: secret)
            guard let jwsTokenSigned = JwsToken(headers: jwsToken.headers,
                                                content: jwsToken.content,
                                                protectedMessage: jwsToken.protectedMessage,
                                                signature: signature,
                                                rawValue: jwsToken.rawValue) else {
                completionBlock(.failure(VCLError(message: "Failed to create signed JwsToken")))
                return
            }
            
            completionBlock(.success(try VCLJwt(encodedJwt: jwsTokenSigned.serialize())))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
            return
        }
    }
    
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        do {
            let keyId = UUID().uuidString
            let secp256k1Signer = Secp256k1Signer()
            let secret = try CryptoOperations().generateKey()
            let publicKey = try secp256k1Signer.getPublicJwk(from: secret, withKeyId: keyId)
            
            let pubKey = ECPublicJwk(x: publicKey.x, y: publicKey.y, keyId: keyId)
            
            completionBlock(.success(VCLDidJwk(value: "\(VCLDidJwk.DidJwkPrefix)\(pubKey.toJson().encodeToBase64())")))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
            return
        }
    }
    
    private func generatePayload(_ jwtDescrptor: VCLJwtDescriptor) -> [String: Any] {
        var retVal = jwtDescrptor.payload
        retVal["iss"] = jwtDescrptor.iss
        retVal["aud"] = jwtDescrptor.iss
        retVal["sub"] = randomString(length: 10)
        retVal["jti"] = jwtDescrptor.jti
        let date = Date()
        retVal["iat"] = date.toDouble()
        retVal["nbf"] = date.toDouble()
        retVal["exp"] = date.addDaysToNow(days: 7).toDouble()
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
}
