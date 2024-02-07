//
//  VCLIdentificationSubmission.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class VCLIdentificationSubmission: VCLSubmission {
    
    init(
        credentialManifest: VCLCredentialManifest,
        verifiableCredentials: [VCLVerifiableCredential]? = nil
    ) {
        super.init(
            submitUri: credentialManifest.submitPresentationUri,
            exchangeId: credentialManifest.exchangeId,
            presentationDefinitionId: credentialManifest.presentationDefinitionId,
            verifiableCredentials: verifiableCredentials,
            vendorOriginContext: credentialManifest.vendorOriginContext,
            didJwk: credentialManifest.didJwk,
            remoteCryptoServicesToken: credentialManifest.remoteCryptoServicesToken
        )
    }
}
