//
//  VCLCredentialManifestDescriptorByDeepLink.swift
//  VCL
//
//  Created by Michael Avoyan on 08/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCredentialManifestDescriptorByDeepLink: VCLCredentialManifestDescriptor {
    public let uri: String?
    public let issuingType: VCLIssuingType
    public let credentialTypes: [String]?
    public let pushDelegate: VCLPushDelegate?
    public let vendorOriginContext: String?
    public let deepLink: VCLDeepLink?
    public let didJwk: VCLDidJwk
    public let remoteCryptoServicesToken: VCLToken?
    public var endpoint: String? { get { return retrieveEndpoint() } }

    
    public init(
        deepLink: VCLDeepLink,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        pushDelegate: VCLPushDelegate? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.uri = deepLink.requestUri
        self.issuingType = issuingType
        self.pushDelegate = pushDelegate
        self.vendorOriginContext = deepLink.vendorOriginContext
        self.deepLink = deepLink
        self.didJwk = didJwk
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
        self.credentialTypes = nil
    }
}
