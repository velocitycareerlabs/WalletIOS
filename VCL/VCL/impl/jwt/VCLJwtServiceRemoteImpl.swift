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
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtServiceUrls.jwtSignServiceUrl,
            body: generatePayloadToVerify(jwt: jwt, jwkPublic: jwkPublic).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { [weak self] isVerifiedJwtResult in
            do {
                if let isVerified = try isVerifiedJwtResult.get().payload.toBool() {
                    completionBlock(.success(isVerified))
                } else {
                    completionBlock(.failure(VCLError(error: "Failed to parse data from \(self?.jwtServiceUrls.jwtSignServiceUrl ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    func sign(
        kid: String?,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: jwtServiceUrls.jwtVerifyServiceUrl,
            body: generateJwtPayloadToSign(kid: kid, nonce: nonce, jwtDescriptor: jwtDescriptor).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { [weak self] seignedJwtResult in
            do {
                if let jwtStr = String(data: try seignedJwtResult.get().payload, encoding: .utf8) {
                    completionBlock(.success(VCLJwt(encodedJwt: jwtStr)))
                } else {
                    completionBlock(.failure(VCLError(error: "Failed to parse data from \(self?.jwtServiceUrls.jwtVerifyServiceUrl ?? "")")))
                    }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func generatePayloadToVerify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic
    ) -> [String: String] {
        return [
            JwtServiceCodingKeys.KeyJwt: jwt.encodedJwt,
            JwtServiceCodingKeys.KeyPublicKey: jwkPublic.valueStr
        ]
    }
    
    private func generateJwtPayloadToSign(
        kid: String?,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor
    ) -> [String: Any] {
        var retVal = [String: Any]()
        retVal[JwtServiceCodingKeys.KeyPayload] = jwtDescriptor.payload
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
}
