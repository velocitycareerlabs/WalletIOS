//
//  VCLCredentialTypeSchema.swift
//  VCL
//
//  Created by Michael Avoyan on 22/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

public struct VCLCredentialTypeSchema {
    public let payload: [String: Any]?
    
    public init(payload: [String: Any]?) {
        self.payload = payload
    }
}
