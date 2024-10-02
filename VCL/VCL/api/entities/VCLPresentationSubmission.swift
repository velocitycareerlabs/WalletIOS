//
//  VCLPresentationSubmission.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLPresentationSubmission: VCLSubmission {
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
    
    public let progressUri: String
    
    public init(
        presentationRequest: VCLPresentationRequest,
        verifiableCredentials: [VCLVerifiableCredential]
    ) {
        self.progressUri = presentationRequest.progressUri
        
        self.submitUri = presentationRequest.submitPresentationUri
        self.exchangeId = presentationRequest.exchangeId
        self.presentationDefinitionId = presentationRequest.presentationDefinitionId
        self.verifiableCredentials = verifiableCredentials
        self.pushDelegate = presentationRequest.pushDelegate
        self.vendorOriginContext = presentationRequest.vendorOriginContext
        self.didJwk = presentationRequest.didJwk
        self.remoteCryptoServicesToken = presentationRequest.remoteCryptoServicesToken
        
    }
}
