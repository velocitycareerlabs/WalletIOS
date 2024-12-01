//
//  VCLGenerateOffersDescriptor.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLGenerateOffersDescriptor {
    public let credentialManifest: VCLCredentialManifest
    public let types: [String]?
    public let offerHashes: [String]?
    public let identificationVerifiableCredentials: [VCLVerifiableCredential]?
    
    public init(
        credentialManifest: VCLCredentialManifest,
        types: [String]? = nil,
        offerHashes: [String]? = nil,
        identificationVerifiableCredentials: [VCLVerifiableCredential]? = nil
    ) {
        self.credentialManifest = credentialManifest
        self.types = types
        self.offerHashes = offerHashes
        self.identificationVerifiableCredentials = identificationVerifiableCredentials
    }
    
    public var payload: [String: Any?] { get {
        [
            CodingKeys.KeyExchangeId: exchangeId,
            CodingKeys.KeyTypes: types ?? [Any](),
            CodingKeys.KeyOfferHashes: offerHashes ?? [Any]()
        ]
    } }
    
    public var issuerId: String { get { credentialManifest.issuerId } }
    public var exchangeId: String { get { credentialManifest.exchangeId } }
    
    public var checkOffersUri: String { get { credentialManifest.checkOffersUri } }

    public struct CodingKeys {
        public static let KeyDid = "did"
        public static let KeyExchangeId = "exchangeId"
        public static let KeyTypes = "types"
        public static let KeyOfferHashes = "offerHashes"
    }
}
