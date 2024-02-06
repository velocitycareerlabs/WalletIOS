//
//  VCLPresentationSubmission.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLPresentationSubmission: VCLSubmission {
    
    public var progressUri: String

    public init(
        presentationRequest: VCLPresentationRequest,
        verifiableCredentials: [VCLVerifiableCredential]
    ) {
        self.progressUri = presentationRequest.progressUri
        
        super.init(
            submitUri: presentationRequest.submitPresentationUri,
            exchangeId: presentationRequest.exchangeId,
            presentationDefinitionId: presentationRequest.presentationDefinitionId,
            verifiableCredentials: verifiableCredentials,
            pushDelegate: presentationRequest.pushDelegate,
            vendorOriginContext: presentationRequest.vendorOriginContext,
            didJwk: presentationRequest.didJwk,
            remoteCryptoServicesToken: presentationRequest.remoteCryptoServicesToken
        )
    }
}
