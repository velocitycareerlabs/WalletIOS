//
//  VCLJwtDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLJwtDescriptor: Sendable {
    /// Json formatted payload
    public let payload: [String: Sendable]?
    /// JWT ID
    public let jti: String
    /// The did of the wallet owner
    public let iss: String
    /// The issuer DID
    public let aud: String?
    
    public init(
        payload: [String : Sendable]? = nil,
        jti: String = UUID().uuidString,
        iss: String,
        aud: String? = nil
    ) {
        self.payload = payload
        self.jti = jti
        self.iss = iss
        self.aud = aud
    }
}
