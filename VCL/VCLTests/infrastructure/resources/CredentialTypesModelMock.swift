//
//  CredentialTypesModelMock.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class CredentialTypesModelMock: CredentialTypesModel {
    
    private let issuerCategory: String

    init(issuerCategory: String) {
        self.issuerCategory = issuerCategory
    }
    
    func credentialTypeByTypeName(type: String) -> VCLCredentialType? {
        return VCLCredentialType(
            payload: "{}".toDictionary() ?? [:],
            credentialType: "",
            issuerCategory: issuerCategory
        )
    }

    var data: VCLCredentialTypes? { get {
        VCLCredentialTypes(all: [VCLCredentialType(payload: "{}".toDictionary() ?? [:], issuerCategory: issuerCategory)])
    } }

    func initialize(
        cacheSequence: Int,
        completionBlock: @escaping @Sendable (VCLResult<VCLCredentialTypes>) -> Void
    ) {
    }

    static let IssuerCategoryNotaryIssuer = "NotaryIssuer"
    static let issuerCategoryRegularIssuer = "RegularIssuer"
//        Identity issuer categories:
    static let IssuerCategoryIdentityIssuer = "IdentityIssuer"
    static let IssuerCategoryIdDocumentIssuer = "IdDocumentIssuer"
    static let IssuerCategoryNotaryIdDocumentIssuer = "NotaryIdDocumentIssuer"
    static let IssuerCategoryContactIssuer = "ContactIssuer"
    static let IssuerCategoryNotaryContactIssuer = "NotaryContactIssuer"
}
