//
//  VCLCredentialType.swift
//  VCL
//
//  Created by Michael Avoyan on 21/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public struct VCLCredentialType: Sendable {
    public let payload: [String: Sendable]
    public let id: String?
    public let schema: String?
    public let createdAt: String?
    public let schemaName: String?
    public let credentialType: String?
    public let recommended: Bool?
    public let jsonldContext: [String]?
    public let issuerCategory: String?
    
    public init(
        payload: [String: Sendable],
        id: String? = nil,
        schema: String? = nil,
        createdAt: String? = nil,
        schemaName: String? = nil,
        credentialType: String? = nil,
        recommended: Bool? = nil,
        jsonldContext: [String]? = nil,
        issuerCategory: String? = nil
    ) {
        self.payload = payload
        self.id = id
        self.schema = schema
        self.createdAt = createdAt
        self.schemaName = schemaName
        self.credentialType = credentialType
        self.recommended = recommended
        self.jsonldContext = jsonldContext
        self.issuerCategory = issuerCategory
    }
    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeySchema = "schema"
        public static let KeyCreatedAt = "createdAt"
        public static let KeySchemaName = "schemaName"
        public static let KeyCredentialType = "credentialType"
        public static let KeyRecommended = "recommended"
        public static let KeyJsonldContext = "jsonldContext"
        public static let KeyIssuerCategory = "issuerCategory"
    }
}

public func == (lhs: VCLCredentialType, rhs: VCLCredentialType) -> Bool {
    return lhs.id == rhs.id &&
    lhs.schema == rhs.schema &&
    lhs.createdAt == rhs.createdAt &&
    lhs.schemaName == rhs.schemaName &&
    lhs.credentialType == rhs.credentialType
}

public func != (lhs: VCLCredentialType, rhs: VCLCredentialType) -> Bool {
    return !(lhs == rhs)
}
