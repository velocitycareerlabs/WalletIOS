//
//  JwtService.swift
//  
//
//  Created by Michael Avoyan on 28/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol JwtService {
    func verify(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    )
    func sign(
        kid: String?,
        nonce: String?,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    )
}

extension JwtService {
    func sign(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        sign(kid: kid, nonce: nonce, jwtDescriptor: jwtDescriptor, completionBlock: completionBlock)
    }
}

public struct JwtServiceCodingKeys {
    public static let KeyIss = "iss"
    public static let KeyAud = "aud"
    public static let KeySub = "sub"
    public static let KeyJti = "jti"
    public static let KeyIat = "iat"
    public static let KeyNbf = "nbf"
    public static let KeyExp = "exp"
    public static let KeyNonce = "nonce"
    
    public static let KeyPayload = "payload"
    public static let KeyJwt = "jwt"
    public static let KeyPublicKey = "publicKey"
}
