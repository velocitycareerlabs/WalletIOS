//
//  JwtServiceMicrosoftImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class JwtServiceMicrosoftImpl: JwtService {
    func decode(encodedJwt: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        completionBlock(.success(VCLJWT(encodedJwt: encodedJwt)))
    }
    
    func encode(jwt: String, completionBlock: @escaping (VCLResult<String>) -> Void) {
        completionBlock(.failure(VCLError(description: "Not implemented")))
    }
    
    func verify(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void) {
        let pubKey = ECPublicJwk(x: publicKey.jwkDict[VCLJWT.CodingKeys.KeyX] as? String ?? "",
                                 y: publicKey.jwkDict[VCLJWT.CodingKeys.KeyY] as? String ?? "",
                                 keyId: publicKey.jwkDict[VCLJWT.CodingKeys.KeyKid] as? String ?? "")
        do {
            let isVerified = try jwt.jwsToken?.verify(using: Secp256k1Verifier(), withPublicKey: pubKey) == true
            completionBlock(.success(isVerified))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
    
    func sign(payload: [String : Any], iss: String, jti: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        do {
            let keyId = UUID().uuidString
            
            let secp256k1Signer = Secp256k1Signer()
            let secret = try CryptoOperations().generateKey()
            let publicKey = try secp256k1Signer.getPublicJwk(from: secret, withKeyId: keyId)
            
            let header = Header(type: GlobalConfig.TypeJwt,
                                algorithm: GlobalConfig.AlgES256K,
                                jsonWebKey: publicKey, // try publicKey.getThumbprint(),
                                keyId: keyId)
            
            let payload = JwtServiceMicrosoftImpl.generatePayload(payload, iss, jti)
            
            let claims = VCLClaims(all: payload)
            let protectedMessage = try? JwtServiceMicrosoftImpl.createProtectedMessage(headers: header, claims: claims)
            guard let jwsToken = JwsToken(headers: header,
                                          content: claims,
                                          protectedMessage: protectedMessage) else {
                completionBlock(.failure(VCLError(description: "Failed to create JwsToken")))
                return
            }
            
            let signature = try secp256k1Signer.sign(token: jwsToken, withSecret: secret)
            guard let jwsTokenSigned = JwsToken(headers: jwsToken.headers,
                                                content: jwsToken.content,
                                                protectedMessage: jwsToken.protectedMessage,
                                                signature: signature,
                                                rawValue: jwsToken.rawValue) else {
                completionBlock(.failure(VCLError(description: "Failed to create signed JwsToken")))
                return
            }
            
//            VERIFICATION TEST:
//            verify(jwt: try VCLJWT(encodedJwt: jwsTokenSigned.serialize()), publicKey: VCLPublicKey(jwk: publicKey.toDictionary() as [String : Any])) {
//            signedJwtResult in
//                do {
//                    let isVerified = try signedJwtResult.get()
//                    NSLog("Verification result -> \(isVerified)")
//                } catch {
//                    NSLog("Verification failed -> \(error)")
//                }
//            }
            
            completionBlock(.success(try VCLJWT(encodedJwt: jwsTokenSigned.serialize())))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
            return
        }
    }
    
    private static func generatePayload(_ payload: [String: Any], _ iss: String, _ jti: String) -> [String: Any] {
        var retVal = payload
        retVal["iss"] = iss
        retVal["aud"] = iss
        retVal["sub"] = randomString(length: 10)
        retVal["jti"] = jti
        let date = Date()
        retVal["iat"] = date.toDouble()
        retVal["nbf"] = date.toDouble()
        retVal["exp"] = date.addDaysToNow(days: 7).toDouble()
        return retVal
    }
    
    private static func createProtectedMessage(headers: Header, claims: VCLClaims) throws -> String {
        let encoder = JSONEncoder()
        let encodedHeader = try encoder.encode(headers).base64URLEncodedString()
        if let encodedContent = claims.all.toJsonString()?.toData().base64URLEncodedString() {
            return encodedHeader  + "." + encodedContent
        } else {
            return encodedHeader
        }
    }
}
