//
//  VCLCredentialType.swift
//  VCL
//
//  Created by Michael Avoyan on 21/03/2021.
//

public struct VCLCredentialType {
    public let payload: [String: Any]
    public let id: String?
    public let schema: String?
    public let createdAt: String?
    public let schemaName: String?
    public let credentialType: String?
    public let recommended: Bool?
    
    public init(payload: [String: Any],
                id: String?,
                schema: String? = nil,
                createdAt: String? = nil,
                schemaName: String? = nil,
                credentialType: String? = nil,
                recommended: Bool? = nil) {
        self.payload = payload
        self.id = id
        self.schema = schema
        self.createdAt = createdAt
        self.schemaName = schemaName
        self.credentialType = credentialType
        self.recommended = recommended
    }
    struct CodingKeys {
        public static let KeyId = "id"
        public static let KeySchema = "schema"
        public static let KeyCreatedAt = "createdAt"
        public static let KeySchemaName = "schemaName"
        public static let KeyCredentialType = "credentialType"
        public static let KeyRecommended = "recommended"
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
