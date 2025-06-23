//
//  VCLCredentialManifestDescriptorRefresh.swift
//  VCL
//
//  Created by Michael Avoyan on 11/04/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCredentialManifestDescriptorRefresh: VCLCredentialManifestDescriptor {
    public let uri: String?
    public let issuingType: VCLIssuingType
    public let credentialTypes: [String]?
    public let pushDelegate: VCLPushDelegate?
    public let vendorOriginContext: String?
    public let deepLink: VCLDeepLink?
    public let didJwk: VCLDidJwk
    public let didInput: String?
    public let remoteCryptoServicesToken: VCLToken?
    public var endpoint: String? { get { return retrieveEndpoint() } }

    let credentialIds:[String]
    
    public init(
        service: VCLService,
        issuingType: VCLIssuingType = VCLIssuingType.Refresh,
        credentialIds:[String],
        didJwk: VCLDidJwk,
        did: String,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.credentialIds = credentialIds
        
        self.uri = service.serviceEndpoint
        self.issuingType = issuingType
        self.didJwk = didJwk
        self.didInput = did
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
        self.credentialTypes = nil
        self.pushDelegate = nil
        self.deepLink = nil
        self.vendorOriginContext = nil
    }

    public var did: String? { get { return self.didInput } }

    public func retrieveEndpoint() -> String? {
        if let queryParams = generateQueryParams() {
            return uri?.appendQueryParams(queryParams: "\(CredentialManifestDescriptorCodingKeys.KeyRefresh)=\(true)&\(queryParams)")
        }
        return uri?.appendQueryParams(queryParams: "\(CredentialManifestDescriptorCodingKeys.KeyRefresh)=\(true)")
    }
    
   public func generateQueryParams() -> String? {
        let pCredentialIds = "\(self.credentialIds.map{ id in "\(CredentialManifestDescriptorCodingKeys.KeyCredentialId)=\(id.encode() ?? "")" }.joined(separator: "&"))"

        let qParams = [pCredentialIds].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
}
