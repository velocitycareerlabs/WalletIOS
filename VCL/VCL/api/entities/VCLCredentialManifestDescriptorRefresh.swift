//
//  VCLCredentialManifestDescriptorRefresh.swift
//  VCL
//
//  Created by Michael Avoyan on 11/04/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLCredentialManifestDescriptorRefresh: VCLCredentialManifestDescriptor {
    let service: VCLService
    let credentialIds:[String]
    
    public init(
        service: VCLService,
        credentialIds:[String]
    ) {
        self.service = service
        self.credentialIds = credentialIds
        
        super.init(uri: service.serviceEndpoint)
    }

    public override var endpoint: String? { get {
        if let queryParams = generateQueryParams() {
            return uri?.appendQueryParams(queryParams: "\(CodingKeys.KeyRefresh)=\(true)&\(queryParams)")
        }
        return uri?.appendQueryParams(queryParams: "\(CodingKeys.KeyRefresh)=\(true)")
    }}
    
    func generateQueryParams() -> String? {
        let pCredentialIds = "\(self.credentialIds.map{ id in "\(CodingKeys.KeyCredentialId)=\(id.encode() ?? "")" }.joined(separator: "&"))"

        let qParams = [pCredentialIds].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
}
