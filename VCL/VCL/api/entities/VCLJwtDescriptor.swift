//
//  VCLJwtDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLJwtDescriptor {
    public let didJwk: VCLDidJwk?
    /// The kid of the badge owner. Must be a did:jwk suffixed with #0
    /// Or
    /// UUID.randomUUID().toString() by default
    public let kid: String
    /// Json formatted payload
    public let payload: [String: Any]?
    /// JWT ID
    public let jti:String
    /// The did of the wallet owner
    public let iss: String
    /// The issuer DID
    public let aud: String?
    /// The time now in seconds since the epoch
    public let iat: Double?
    /// The expiration time in days
    public let nbf: Int?
    /// The challenge value returned on the token request
    public let nonce: String?
    
    public init(
        didJwk: VCLDidJwk? = nil,
        kid: String = UUID().uuidString,
        payload: [String : Any]? = nil,
        jti: String = UUID().uuidString,
        iss: String,
        aud: String? = nil,
        iat: Double? = nil,
        nbf: Int? = nil,
        nonce: String? = nil
    ) {
        self.didJwk = didJwk
        self.kid = kid
        self.payload = payload
        self.jti = jti
        self.iss = iss
        self.aud = aud
        self.iat = iat
        self.nbf = nbf
        self.nonce = nonce
    }
}
