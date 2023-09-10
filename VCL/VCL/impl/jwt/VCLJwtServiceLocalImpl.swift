//
//  VCLJwtServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class VCLJwtServiceLocalImpl: VCLJwtService {
    
    private let keyService: VCLKeyService
    private let tokenSigning: TokenSigning
    
    init(_ keyService: VCLKeyService) {
        self.keyService = keyService
        self.tokenSigning = Secp256k1Signer() // No need to be injected
    }
    
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        do {
            let pubKey = ECPublicJwk(
                x: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyX] as? String ?? "",
                y: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyY] as? String ?? "",
                keyId: jwkPublic.valueDict[VCLJwt.CodingKeys.KeyKid] as? String ?? ""
            )
            completionBlock(.success(try jwt.jwsToken?.verify(using: TokenVerifier(), withPublicKey: pubKey) == true))
        } catch {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
    
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
            let secp256k1Signer = Secp256k1Signer()
            getSecretReference(
                keyId: jwtDescriptor.keyId,
                completionBlock: { [weak self] secretResult in
                    do {
                        let secret = try secretResult.get()
                        self?.keyService.retrievePublicJwk(
                            secret: secret,
                            completionBlock: { publicJwkResult in
                                do {
                                    let publicJwk = try publicJwkResult.get()
                                    
                                    var header = Header(
                                        type: GlobalConfig.TypeJwt,
                                        algorithm: GlobalConfig.AlgES256K,
                                        jsonWebKey: publicJwk
                                    )
                                    if let kid = kid {
                                        header = Header(
                                            type: GlobalConfig.TypeJwt,
                                            algorithm: GlobalConfig.AlgES256K,
                                            keyId: kid
                                        )
                                    }
                                    let claims = VCLClaims(all: self?.generateClaims(nonce: nonce, jwtDescriptor: jwtDescriptor) ?? [:])
                                    
                                    let protectedMessage = try? self?.createProtectedMessage(headers: header, claims: claims)
                                    
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
                                    completionBlock(.success(try VCLJwt(encodedJwt: jwsTokenSigned.serialize())))
                                } catch {
                                    completionBlock(.failure(VCLError(error: error)))
                                }
                            }
                        )
                    } catch {
                        completionBlock(.failure(VCLError(error: error)))
                    }
                }
            )
    }
    
    private func getSecretReference(
        keyId: String?,
        completionBlock: @escaping (VCLResult<VCCryptoSecret>) -> Void
    ) {
        if let keyId = keyId {
            keyService.retrieveSecretReference(keyId: keyId, completionBlock: completionBlock)
        } else {
            keyService.generateSecret(completionBlock: completionBlock)
        }
    }
    
    private func generateClaims(
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = jwtDescriptor.payload ?? [String: Any]()
        retVal[JwtServiceCodingKeys.KeyIss] = jwtDescriptor.iss
        retVal[JwtServiceCodingKeys.KeyAud] = jwtDescriptor.aud
        retVal[JwtServiceCodingKeys.KeySub] = randomString(length: 10)
        retVal[JwtServiceCodingKeys.KeyJti] = jwtDescriptor.jti
        let date = Date()
        retVal[JwtServiceCodingKeys.KeyIat] = date.toDouble()
        retVal[JwtServiceCodingKeys.KeyNbf] = date.toDouble()
        retVal[JwtServiceCodingKeys.KeyExp] = date.addDays(days: 7).toDouble()
        if let nonce = nonce {
            retVal[JwtServiceCodingKeys.KeyNonce] = nonce
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
}
