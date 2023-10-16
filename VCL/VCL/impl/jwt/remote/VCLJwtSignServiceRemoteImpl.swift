//
//  VCLJwtSignServiceRemoteImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 03/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class VCLJwtSignServiceRemoteImpl: VCLJwtSignService {
    
    private let networkService: NetworkService
    private let jwtSignServiceUrl: String
    
    init(_ networkService: NetworkService, _ jwtSignServiceUrl: String) {
        self.networkService = networkService
        self.jwtSignServiceUrl = jwtSignServiceUrl
    }
    
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtSignServiceUrl,
            body: generateJwtPayloadToSign(nonce: nonce, jwtDescriptor: jwtDescriptor).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [
                (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion),
                (HeaderKeys.Authorization, "\(HeaderKeys.Bearer) \(remoteCryptoServicesToken?.value ?? "")")
            ]
        ) { [weak self] signedJwtResult in
            do {
                if let jwtStr = try signedJwtResult.get().payload.toDictionary()?[CodingKeys.KeyCompactJwt] as? String {
                    completionBlock(.success(VCLJwt(encodedJwt: jwtStr)))
                } else {
                    completionBlock(.failure(VCLError(payload: "Failed to parse data from \(self?.jwtSignServiceUrl ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func generateJwtPayloadToSign(
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = [String: Any]()
        var options = [String: Any]()
        var payload = jwtDescriptor.payload ?? [:]

        options[CodingKeys.KeyKeyId] = jwtDescriptor.keyId
        options[CodingKeys.KeyAud] = jwtDescriptor.aud
        options[CodingKeys.KeyJti] = jwtDescriptor.jti
        options[CodingKeys.KeyIss] = jwtDescriptor.iss
        options[CodingKeys.KeyIss] = jwtDescriptor.iss
        
        payload[CodingKeys.KeyNonce] = nonce

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

        public static let KeyCompactJwt = "compactJwt"
    }
}