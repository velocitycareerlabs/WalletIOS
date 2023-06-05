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
    
    private let keyService: KeyService
    private let tokenSigning: TokenSigning
    
    init(_ keyService: KeyService) {
        self.keyService = keyService
        self.tokenSigning = Secp256k1Signer() // No need to be injected
    }
    
    func decode(encodedJwt: String) -> VCLJwt {
        return VCLJwt(encodedJwt: encodedJwt)
    }

    func encode(jwt: String) -> VCLJwt {
        return VCLJwt(encodedJwt: "not implemented yet")
    }
    
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic
    ) throws -> Bool {
        let pubKey = ECPublicJwk(
            x: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
            y: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
            keyId: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? ""
        )
        return try jwt.jwsToken?.verify(using: TokenVerifier(), withPublicKey: pubKey) == true
    }
    
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor
    ) throws -> VCLJwt {
        do {
            let secp256k1Signer = Secp256k1Signer()
            
            var secret: VCCryptoSecret
            if let keyId = jwtDescriptor.keyId {
                secret = try keyService.retrieveSecretReference(keyId: keyId)
            } else {
                secret = try keyService.generateSecret()
            }
            let publicJwk = try keyService.retrievePublicJwk(secret: secret)
            
            var header = Header(
                type: GlobalConfig.TypeJwt,
                algorithm: GlobalConfig.AlgES256K,
                jsonWebKey: publicJwk
            )
            if let kid = kid {
                header = Header(
                    type: GlobalConfig.TypeJwt,
                    algorithm: GlobalConfig.AlgES256K,
                    jsonWebKey: publicJwk,
                    keyId: kid
                )
            }
            let claims = VCLClaims(all: generateClaims(nonce: nonce, jwtDescriptor: jwtDescriptor))
            
            let protectedMessage = try? createProtectedMessage(headers: header, claims: claims)
            
            guard let jwsToken = JwsToken(
                headers: header,
                content: claims,
                protectedMessage: protectedMessage
            ) else {
                throw VCLError(message: "Failed to create JwsToken")
            }
            
            let signature = try secp256k1Signer.sign(token: jwsToken, withSecret: secret)
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
    
    private func generateClaims(
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = jwtDescriptor.payload ?? [String: Any]()
        retVal[CodingKeys.KeyIss] = jwtDescriptor.iss
        retVal[CodingKeys.KeyAud] = jwtDescriptor.aud
        retVal[CodingKeys.KeySub] = randomString(length: 10)
        retVal[CodingKeys.KeyJti] = jwtDescriptor.jti
        let date = Date()
        retVal[CodingKeys.KeyIat] = date.toDouble()
        retVal[CodingKeys.KeyNbf] = date.toDouble()
        retVal[CodingKeys.KeyExp] = date.addDays(days: 7).toDouble()
        if let nonce = nonce {
            retVal[CodingKeys.KeyNonce] = nonce
        }
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
    
    public struct CodingKeys {
        public static let KeyIss = "iss"
        public static let KeyAud = "aud"
        public static let KeySub = "sub"
        public static let KeyJti = "jti"
        public static let KeyIat = "iat"
        public static let KeyNbf = "nbf"
        public static let KeyExp = "exp"
        public static let KeyNonce = "nonce"
    }
}
