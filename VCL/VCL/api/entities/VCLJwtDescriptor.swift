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
    ///  The kid of the owner, UUID by default
    public let kid: String
    /// Json formatted payload
    public let payload: [String: Any]
    /// JWT ID
    public let jti:String
    /// The did of the wallet owner
    public let iss: String
    /// The issuer DID
    public let aud: String?
    
    public init(
        didJwk: VCLDidJwk? = nil,
        kid: String = UUID().uuidString,
        payload: [String : Any],
        jti: String = UUID().uuidString,
        iss: String,
        aud: String? = nil,
        nonce: String? = nil
    ) {
        self.didJwk = didJwk
        self.kid = kid
        self.payload = payload
        self.jti = jti
        self.iss = iss
        self.aud = aud
    }
}
