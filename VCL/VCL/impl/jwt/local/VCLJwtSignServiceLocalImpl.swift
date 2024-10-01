//
//  VCLJwtSignServiceLocalImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@preconcurrency import VCToken
@preconcurrency import VCCrypto

final class VCLJwtSignServiceLocalImpl: VCLJwtSignService {
    
    private let keyService: VCLKeyService
    private let tokenSigning: TokenSigning
    
    init(_ keyService: VCLKeyService) {
        self.keyService = keyService
        self.tokenSigning = Secp256k1Signer() // No need to be injected
    }
    
    func sign(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping @Sendable (VCLResult<VCLJwt>) -> Void
    ) {
            let secp256k1Signer = Secp256k1Signer()
            getSecretReference(
                keyId: didJwk.keyId,
                completionBlock: { [weak self] secretResult in
                    guard let self = self else { return }
                    do {
                        let secret = try secretResult.get()
                        self.keyService.retrievePublicJwk(
                            secret: secret,
                            completionBlock: { publicJwkResult in
                                do {
                                    let publicJwk = try publicJwkResult.get()
                                    
                                    var header = Header(
                                        type: GlobalConfig.TypeJwt,
                                        algorithm: VCLSignatureAlgorithm.fromString(value: didJwk.publicJwk.curve).jwsAlgorithm,
                                        jsonWebKey: publicJwk,
                                        keyId: didJwk.kid
                                    )
                                    let claims = VCLClaims(all: self.generateClaims(jwtDescriptor: jwtDescriptor, nonce: nonce))
                                    
                                    let protectedMessage = try?self.createProtectedMessage(headers: header, claims: claims)
                                    
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
        keyId: String,
        completionBlock: @escaping @Sendable (VCLResult<VCCryptoSecret>) -> Void
    ) {
        keyService.retrieveSecretReference(keyId: keyId, completionBlock: completionBlock)
    }
    
    private func generateClaims(
        jwtDescriptor: VCLJwtDescriptor,
        nonce: String?
    ) -> [String: Sendable] {
        var retVal = jwtDescriptor.payload ?? [String: Sendable]()
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
