//
//  VCLCredentialTypesFormSchema.swift
//  VCL
//
//  Created by Michael Avoyan on 13/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCredentialTypesUIFormSchema: Sendable {
    public let payload: [String: Sendable]
    
    public init(payload: [String: Sendable]) {
        self.payload = payload
    }
    
    public struct CodingKeys {
        public static let KeyAddressRegion = "addressRegion"
        public static let KeyAddressCountry = "addressCountry"
        public static let KeyUiEnum = "ui:enum"
        public static let KeyUiNames = "ui:enumNames"
    }
}
