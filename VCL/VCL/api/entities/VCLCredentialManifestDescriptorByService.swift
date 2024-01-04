//
//  VCLCredentialManifestDescriptorByOrganization.swift
//  VVL
//
//  Created by Michael Avoyan on 09/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLCredentialManifestDescriptorByService: VCLCredentialManifestDescriptor {
    private let service: VCLService // for log
    public init(
        service: VCLService,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        credentialTypes: [String]? = nil,
        pushDelegate: VCLPushDelegate? = nil
    ) {
        self.service = service
        super.init(
            uri: service.serviceEndpoint,
            issuingType: issuingType,
            credentialTypes: credentialTypes,
            pushDelegate: pushDelegate
        )
    }
    
    public override func toPropsString() -> String {
        var propsString = super.toPropsString()
            propsString += "\nservice: \(service.toPropsString())"
            return propsString
    }
}
