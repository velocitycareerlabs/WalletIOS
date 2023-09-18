//
//  VCLJwtServiceRemoteImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 08/06/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class VCLJwtServiceRemoteImpl: VCLJwtService {
    
    private let networkService: NetworkService
    private let jwtServiceUrls: VCLJwtServiceUrls
    
    init(_ networkService: NetworkService, _ jwtServiceUrls: VCLJwtServiceUrls) {
        self.networkService = networkService
        self.jwtServiceUrls = jwtServiceUrls
    }
    
    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtServiceUrls.jwtVerifyServiceUrl,
            body: generatePayloadToVerify(jwt: jwt, publicJwk: publicJwk).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { verifiedJwtResult in
            do {
                let payloadDict = try verifiedJwtResult.get().payload.toDictionary()
                let isVerified = (payloadDict?[CodingKeys.KeyVerified] as? Int) == 1
                completionBlock(.success(isVerified))
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtServiceUrls.jwtSignServiceUrl,
            body: generateJwtPayloadToSign(nonce: nonce, jwtDescriptor: jwtDescriptor).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: generateHeader(kid: kid)
        ) { [weak self] signedJwtResult in
            do {
                if let jwtStr = try signedJwtResult.get().payload.toDictionary()?[CodingKeys.KeyJwt] as? String {
                    completionBlock(.success(VCLJwt(encodedJwt: jwtStr)))
                } else {
                    completionBlock(.failure(VCLError(payload: "Failed to parse data from \(self?.jwtServiceUrls.jwtVerifyServiceUrl ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func generatePayloadToVerify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk
    ) -> [String: Any] {
        return [
            CodingKeys.KeyJwt: jwt.encodedJwt,
            CodingKeys.KeyPublicKey: publicJwk.valueDict
        ]
    }
    
    private func generateHeader(kid: String? = nil) -> [(String, String)] {
        let protocolTuple = (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)
        if let kid = kid {
            return [protocolTuple, (CodingKeys.KeyKid, kid)]
        }
        return [protocolTuple]
    }
    
    private func generateJwtPayloadToSign(
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = [String: Any]()
        var options = [String: Any]()
//        var required = [String: Any]()
        
        if let aud = jwtDescriptor.aud {
            options[CodingKeys.KeyAudience] = aud
        }
        options[CodingKeys.KeyJti] = jwtDescriptor.jti
        let date = Date()
//        options[JwtServiceCodingKeys.KeyIssuedAt] = date.toDouble()
//        options[JwtServiceCodingKeys.KeyNotBefore] = date.toDouble()
//        options[JwtServiceCodingKeys.KeyExpiresIn] = date.addDays(days: 7).toDouble()
        if let nonce = nonce {
            options[CodingKeys.KeyNonce] = nonce
        }
        options[CodingKeys.KeyIssuer] = jwtDescriptor.iss
        options[CodingKeys.KeySubject] = randomString(length: 10)
        
        if let payload = jwtDescriptor.payload {
            retVal[CodingKeys.KeyPayload] = payload
        }
        retVal[CodingKeys.KeyOptions] = options
//        retVal[JwtServiceCodingKeys.KeyRequired] = required
        
        return retVal
    }
    
    public struct CodingKeys {
        public static let KeyKid = "kid"
        
        public static let KeyIssuer = "issuer"
        public static let KeyAudience = "audience"
        public static let KeySubject = "subject"
        public static let KeyJti = "jti"
//        public static let KeyIssuedAt = "issuedAt"
//        public static let KeyNotBefore = "notBefore"
//        public static let KeyExpiresIn = "expiresIn"
        public static let KeyNonce = "nonce"
        
        public static let KeyPayload = "payload"
        public static let KeyJwt = "jwt"
        public static let KeyPublicKey = "publicKey"
        
        public static let KeyOptions = "options"
        public static let KeyRequired = "required"
        
        public static let KeyVerified = "verified"
    }
}
