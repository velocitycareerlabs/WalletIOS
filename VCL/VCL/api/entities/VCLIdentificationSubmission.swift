//
//  VCLIdentificationSubmission.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLIdentificationSubmission: VCLSubmission {
    public let submitUri: String
    public let exchangeId: String
    public let presentationDefinitionId: String
    public let verifiableCredentials: [VCLVerifiableCredential]?
    public let pushDelegate: VCLPushDelegate?
    public let vendorOriginContext: String?
    public let didJwk: VCLDidJwk
    public let remoteCryptoServicesToken: VCLToken?

    public let jti = UUID().uuidString
    public let submissionId = UUID().uuidString
    
    
    public init(
        credentialManifest: VCLCredentialManifest,
        verifiableCredentials: [VCLVerifiableCredential]? = nil
    ) {
        self.submitUri = credentialManifest.submitPresentationUri
        self.exchangeId = credentialManifest.exchangeId
        self.presentationDefinitionId = credentialManifest.presentationDefinitionId
        self.verifiableCredentials = verifiableCredentials
        self.vendorOriginContext = credentialManifest.vendorOriginContext
        self.didJwk = credentialManifest.didJwk
        self.remoteCryptoServicesToken = credentialManifest.remoteCryptoServicesToken
        self.pushDelegate = nil
    }
}
