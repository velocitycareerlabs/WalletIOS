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
        didJwk: VCLDidJwk,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtSignServiceUrl,
            body: generateJwtPayloadToSign(didJwk: didJwk, nonce: nonce, jwtDescriptor: jwtDescriptor).toJsonString(),
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
    
    internal func generateJwtPayloadToSign(
        didJwk: VCLDidJwk,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = [String: Any]()
        var header = [String: Any]()
        var options = [String: Any]()
        var payload = jwtDescriptor.payload ?? [:]
        
//        HeaderValues.XVnfProtocolVersion == VCLXVnfProtocolVersion.XVnfProtocolVersion1
        header[CodingKeys.KeyJwk] = didJwk.publicJwk.valueDict
//        HeaderValues.XVnfProtocolVersion == VCLXVnfProtocolVersion.XVnfProtocolVersion2
        header[CodingKeys.KeyKid] = didJwk.kid
        
        options[CodingKeys.KeyKeyId] = didJwk.keyId
        
        payload[CodingKeys.KeyNonce] = nonce
        payload[CodingKeys.KeyAud] = jwtDescriptor.aud
        payload[CodingKeys.KeyJti] = jwtDescriptor.jti
        payload[CodingKeys.KeyIss] = jwtDescriptor.iss

        retVal[CodingKeys.KeyHeader] = header
        retVal[CodingKeys.KeyOptions] = options
        retVal[CodingKeys.KeyPayload] = payload

        return retVal
    }

    public struct CodingKeys {
        public static let KeyKeyId = "keyId"
        public static let KeyJwk = "jwk"
        public static let KeyKid = "kid"
        public static let KeyIss = "iss"
        public static let KeyAud = "aud"
        public static let KeyJti = "jti"
        public static let KeyNonce = "nonce"

        public static let KeyHeader = "header"
        public static let KeyOptions = "options"
        public static let KeyPayload = "payload"

        public static let KeyCompactJwt = "compactJwt"
    }
}
