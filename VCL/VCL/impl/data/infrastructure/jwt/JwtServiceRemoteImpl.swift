//
//  JwtServiceRemoteImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 08/06/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class JwtServiceRemoteImpl: JwtService {
    
    private static let JwtBaseUrl = "https://devcareerwallet.velocitycareerlabs.io/api/v0.6"
    private static let SignJwtUrl = "\(JwtBaseUrl)/jwt/sign"
    private static let VerifyJwtUrl = "\(JwtBaseUrl)/jwt/verify"
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        networkService.sendRequest(
            endpoint: JwtServiceRemoteImpl.SignJwtUrl,
            body: generatePayloadToVerify(jwt: jwt, jwkPublic: jwkPublic).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { isVerifiedJwtResult in
            do {
                if let isVerified = try isVerifiedJwtResult.get().payload.toBool() {
                    completionBlock(.success(isVerified))
                } else {
                    completionBlock(.failure(VCLError(error: "Failed to parse data from \(JwtServiceRemoteImpl.SignJwtUrl)")))
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
            endpoint: JwtServiceRemoteImpl.SignJwtUrl,
            body: generateJwtPayloadToSign(kid: kid, nonce: nonce, jwtDescriptor: jwtDescriptor).toJsonString(),
            contentType: .ApplicationJson,
            method: .POST,
            headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        ) { seignedJwtResult in
            do {
                if let jwtStr = String(data: try seignedJwtResult.get().payload, encoding: .utf8) {
                    completionBlock(.success(VCLJwt(encodedJwt: jwtStr)))
                } else {
                        completionBlock(.failure(VCLError(error: "Failed to parse data from \(JwtServiceRemoteImpl.SignJwtUrl)")))
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
