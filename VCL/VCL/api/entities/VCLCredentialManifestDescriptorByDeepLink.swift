//
//  VCLCredentialManifestDescriptorByDeepLink.swift
//  VCL
//
//  Created by Michael Avoyan on 08/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLCredentialManifestDescriptorByDeepLink: VCLCredentialManifestDescriptor {
    
    public init(
        deepLink: VCLDeepLink,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        pushDelegate: VCLPushDelegate? = nil,
        didJwk: VCLDidJwk? = nil,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        super.init(
            uri: deepLink.requestUri,
            issuingType: issuingType,
            pushDelegate: pushDelegate,
            vendorOriginContext: deepLink.vendorOriginContext,
            deepLink: deepLink,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken
        )
    }
}
