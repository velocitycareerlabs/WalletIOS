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
                let isVerified = (payloadDict?[CodingKeys.KeyVerified] as? Bool) == true
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
            method: .POST
        ) { [weak self] signedJwtResult in
            do {
                if let jwtStr = try signedJwtResult.get().payload.toDictionary()?[CodingKeys.KeyCompactJwt] as? String {
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
    
    private func generateJwtPayloadToSign(
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = [String: Any]()
        var options = [String: Any]()
        var payload = jwtDescriptor.payload

        options[CodingKeys.KeyKeyId] = jwtDescriptor.keyId
        options[CodingKeys.KeyAud] = jwtDescriptor.aud
        options[CodingKeys.KeyJti] = jwtDescriptor.jti
        options[CodingKeys.KeyIss] = jwtDescriptor.iss
        options[CodingKeys.KeyIss] = jwtDescriptor.iss
        
        payload?[CodingKeys.KeyNonce] = nonce

        retVal[CodingKeys.KeyOptions] = options
        retVal[CodingKeys.KeyPayload] = payload

        return retVal
    }

    public struct CodingKeys {
        public static let KeyKeyId = "keyId"
        public static let KeyIss = "iss"
        public static let KeyAud = "aud"
        public static let KeyJti = "jti"
        public static let KeyNonce = "nonce"

        public static let KeyOptions = "options"
        public static let KeyPayload = "payload"

        public static let KeyJwt = "jwt"
        public static let KeyCompactJwt = "compactJwt"
        public static let KeyVerified = "verified"

        public static let KeyPublicKey = "publicKey"
    }
}
