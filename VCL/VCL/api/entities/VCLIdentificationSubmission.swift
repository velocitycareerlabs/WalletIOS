//
//  VCLIdentificationSubmission.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//

import Foundation

class VCLIdentificationSubmission: VCLSubmission {
    
    init(credentialManifest: VCLCredentialManifest,
         verifiableCredentials: [VCLVerifiableCredential]) {
        super.init(submitUri: credentialManifest.submitPresentationUri,
                   iss: credentialManifest.iss,
                   exchangeId: credentialManifest.exchangeId,
                   presentationDefinitionId: credentialManifest.presentationDefinitionId,
                   verifiableCredentials: verifiableCredentials,
                   vendorOriginContext: credentialManifest.vendorOriginContext)
    }
}
