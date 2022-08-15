//
//  VCLPresentationSubmission.swift
//  
//
//  Created by Michael Avoyan on 19/04/2021.
//

import Foundation

public class VCLPresentationSubmission: VCLSubmission {
    
    public var progressUri: String

    public init(presentationRequest: VCLPresentationRequest,
                verifiableCredentials: [VCLVerifiableCredential]) {
        
        self.progressUri = presentationRequest.progressUri
        
        super.init(submitUri: presentationRequest.submitPresentationUri,
                   iss: presentationRequest.iss,
                   exchangeId: presentationRequest.exchangeId,
                   presentationDefinitionId: presentationRequest.presentationDefinitionId,
                   verifiableCredentials: verifiableCredentials,
                   vendorOriginContext: presentationRequest.vendorOriginContext)
        
    }
}
