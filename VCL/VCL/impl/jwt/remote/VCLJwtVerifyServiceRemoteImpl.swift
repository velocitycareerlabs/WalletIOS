//
//  VCLJwtVerifyServiceRemoteImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class VCLJwtVerifyServiceRemoteImpl: VCLJwtVerifyService {
    
    private let networkService: NetworkService
    private let jwtVerifyServiceUrl: String
    
    init(_ networkService: NetworkService, _ jwtVerifyServiceUrl: String) {
        self.networkService = networkService
        self.jwtVerifyServiceUrl = jwtVerifyServiceUrl
    }
    
    func verify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtVerifyServiceUrl,
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
    
    private func generatePayloadToVerify(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk
    ) -> [String: Any] {
        return [
            CodingKeys.KeyJwt: jwt.encodedJwt,
            CodingKeys.KeyPublicKey: publicJwk.valueDict
        ]
    }
    
    public struct CodingKeys {
        public static let KeyJwt = "jwt"
        public static let KeyVerified = "verified"

        public static let KeyPublicKey = "publicKey"
    }
}
