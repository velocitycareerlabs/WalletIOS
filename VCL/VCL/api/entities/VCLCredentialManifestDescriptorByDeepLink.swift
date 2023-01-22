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
        serviceType: VCLServiceType
    ) {
        super.init(
            uri: deepLink.requestUri,
            serviceType: serviceType
        )
    }
}
