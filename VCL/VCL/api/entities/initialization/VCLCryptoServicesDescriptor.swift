//
//  VCLKeyServicesDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 06/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCryptoServicesDescriptor {
    public let cryptoServiceType: VCLCryptoServiceType
    public let signatureAlgorithm: VCLSignatureAlgorithm
    public let injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor?
    public let remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor?
    
    public init(
        cryptoServiceType: VCLCryptoServiceType = VCLCryptoServiceType.Local,
        signatureAlgorithm: VCLSignatureAlgorithm = VCLSignatureAlgorithm.ES256,
        injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor? = nil,
        remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor? = nil
    ) {
        self.cryptoServiceType = cryptoServiceType
        self.signatureAlgorithm = signatureAlgorithm
        self.injectedCryptoServicesDescriptor = injectedCryptoServicesDescriptor
        self.remoteCryptoServicesUrlsDescriptor = remoteCryptoServicesUrlsDescriptor
    }
}
