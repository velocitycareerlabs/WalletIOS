//
//  VCSDKConfiguration.swift
//  VCL
//
//  Created by Michael Avoyan on 04/04/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import VCCrypto

final class VCSDKConfiguration: VCSDKConfigurable {
    var accessGroupIdentifier: String?
    
    init(accessGroupIdentifier: String?) {
        self.accessGroupIdentifier = accessGroupIdentifier
    }
}
