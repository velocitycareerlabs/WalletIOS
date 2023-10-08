//
//  VCLJwtSignServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCToken
import VCCrypto

class VCLJwtSignServiceLocalImpl: VCLJwtSignService {
    
    private let keyService: VCLKeyService
    private let tokenSigning: TokenSigning
    
    init(_ keyService: VCLKeyService) {
        self.keyService = keyService
        self.tokenSigning = Secp256k1Signer() // No need to be injected
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
