//
//  VCLServices.swift
//  VCL
//
//  Created by Michael Avoyan on 14/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLServiceTypes {

    public let all: [VCLServiceType]
    
    public init(all: [VCLServiceType]) {
        self.all = all
    }

    public convenience init(serviceType: VCLServiceType) {
        self.init(all: [serviceType])
    }
    
    public convenience init(issuingType: VCLIssuingType) {
        var all: [VCLServiceType]
        switch(issuingType) {
        case VCLIssuingType.Career:
            all = [
                VCLServiceType.Issuer,
                VCLServiceType.CareerIssuer,
                VCLServiceType.NotaryIssuer
            ]
        case VCLIssuingType.Identity:
            all = [VCLServiceType.IdentityIssuer]
        case VCLIssuingType.Refresh:
            all = [
                VCLServiceType.Issuer,
                VCLServiceType.CareerIssuer,
                VCLServiceType.NotaryIssuer,
                VCLServiceType.IdentityIssuer
            ]
        case VCLIssuingType.Undefined:
            all = [VCLServiceType.Undefined]
        }
        self.init(all: all)
    }

    func containsAtLeastOneOf(serviceTypes: VCLServiceTypes) -> Bool {
        return all.first { serviceTypes.all.contains($0) && $0 != VCLServiceType.Undefined } != nil
    }
    
    func contains(serviceType: VCLServiceType) -> Bool {
        return all.contains(serviceType) && serviceType != VCLServiceType.Undefined
    }
}
