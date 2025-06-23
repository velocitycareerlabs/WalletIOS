//
//  VCLCredentialManifestDescriptorByOrganization.swift
//  VVL
//
//  Created by Michael Avoyan on 09/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCredentialManifestDescriptorByService: VCLCredentialManifestDescriptor {
    public var uri: String?
    public var issuingType: VCLIssuingType
    public var credentialTypes: [String]?
    public var pushDelegate: VCLPushDelegate?
    public var vendorOriginContext: String?
    public var deepLink: VCLDeepLink?
    public var didJwk: VCLDidJwk
    public let didInput: String?
    public var remoteCryptoServicesToken: VCLToken?
    public var endpoint: String? { get { return retrieveEndpoint() } }
    private let service: VCLService // for log
    
    public init(
        service: VCLService,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        credentialTypes: [String]? = nil,
        pushDelegate: VCLPushDelegate? = nil,
        didJwk: VCLDidJwk,
        did: String,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.service = service
        
        self.uri = service.serviceEndpoint
        self.issuingType = issuingType
        self.credentialTypes = credentialTypes
        self.pushDelegate = pushDelegate
        self.didJwk = didJwk
        self.didInput = did
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
    }
    
    public var did: String? { get { return self.didInput } }
        
    public func toPropsString() -> String {
        var propsString = "\nuri: \(uri ?? "")"
        propsString += "\ndid: \(did ?? "")"
        propsString += "\nissuingType: \(issuingType)"
        propsString += "\ncredentialTypes: \(String(describing: credentialTypes))"
        propsString += "\npushDelegate: \(pushDelegate?.toPropsString() ?? "")"
        propsString += "\nvendorOriginContext: \(vendorOriginContext ?? "")"
        propsString += "\nservice: \(service.toPropsString())"
        return propsString
    }
}
