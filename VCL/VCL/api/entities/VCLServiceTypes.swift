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
    
    public func contains(serviceType: VCLServiceType) -> Bool {
        all.filter { $0 == serviceType && serviceType != VCLServiceType.Undefined }.isEmpty == false
    }
}
