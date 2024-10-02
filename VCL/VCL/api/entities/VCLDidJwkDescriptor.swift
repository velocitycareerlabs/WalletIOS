//
//  VCLDidJwkDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 18/02/2024.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLDidJwkDescriptor: Sendable {
    public let signatureAlgorithm: VCLSignatureAlgorithm
    public let remoteCryptoServicesToken: VCLToken?
    
    public init(
        signatureAlgorithm: VCLSignatureAlgorithm = VCLSignatureAlgorithm.ES256,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.signatureAlgorithm = signatureAlgorithm
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
    }
}
