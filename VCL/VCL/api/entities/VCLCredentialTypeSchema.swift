//
//  VCLCredentialTypeSchema.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public struct VCLCredentialTypeSchema: Sendable {
    public let payload: [String: Sendable]?
    
    public init(payload: [String: Sendable]?) {
        self.payload = payload
    }
}
