//
//  VCLCredentialManifestDescriptorByOrganization.swift
//  VVL
//
//  Created by Michael Avoyan on 09/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLCredentialManifestDescriptorByService: VCLCredentialManifestDescriptor {
    
    public init(
        service: VCLService,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        credentialTypes: [String]? = nil,
        pushDelegate: VCLPushDelegate? = nil
    ) {
        super.init(
            uri: service.serviceEndpoint,
            issuingType: issuingType,
            credentialTypes: credentialTypes,
            pushDelegate: pushDelegate)
    }
///    TODO: validate credentialTypes by services.credentialTypes
    
    public override var endpoint: String? { get {
        if let queryParams = generateQueryParams() {
            return self.uri?.appendQueryParams(queryParams: queryParams)
        } else {
            return self.uri
        }
    }}
    
    func generateQueryParams() -> String? {
        var pCredentialTypes: String? = nil
        var pPushDelegate: String? = nil
        var pPushToken: String? = nil
                
        if let credentialTypes = self.credentialTypes {
            pCredentialTypes = "\(credentialTypes.map{ type in "\(CodingKeys.KeyCredentialTypes)=\(type.encode() ?? "")" }.joined(separator: "&"))"
        }
        if let pushUrl = self.pushDelegate?.pushUrl {
            pPushDelegate = "\(CodingKeys.KeyPushDelegatePushUrl)=\(pushUrl.encode() ?? "")"
        }
        if let pushToken = self.pushDelegate?.pushToken {
            pPushToken = "\(CodingKeys.KeyPushDelegatePushToken)=\(pushToken.encode() ?? "")"
        }
        let qParams = [
            pCredentialTypes,
            pPushDelegate,
            pPushToken
        ].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
}
