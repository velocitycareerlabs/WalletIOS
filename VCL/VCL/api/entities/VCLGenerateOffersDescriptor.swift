//
//  VCLGenerateOffersDescriptor.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLGenerateOffersDescriptor {
    public let credentialManifest: VCLCredentialManifest
    public let types: [String]?
    public let offerHashes: [String]?
    public let identificationVerifiableCredentials: [VCLVerifiableCredential]
    
    public init(credentialManifest: VCLCredentialManifest,
                types: [String]? = nil,
                offerHashes: [String]? = nil,
                identificationVerifiableCredentials: [VCLVerifiableCredential]) {
        self.credentialManifest = credentialManifest
        self.types = types
        self.offerHashes = offerHashes
        self.identificationVerifiableCredentials = identificationVerifiableCredentials
    }
    
    var payload: [String: Any?] { get {
        [
            CodingKeys.KeyExchangeId: exchangeId,
            CodingKeys.KeyTypes: types ?? [Any](),
            CodingKeys.KeyOfferHashes: offerHashes ?? [Any]()
        ]
    } }
    
    var did: String { get { credentialManifest.did } }
    var exchangeId: String { get { credentialManifest.exchangeId } }
    
    var checkOffersUri: String { get { credentialManifest.checkOffersUri } }

    struct CodingKeys {
        static let KeyDid = "did"
        static let KeyExchangeId = "exchangeId"
        static let KeyTypes = "types"
        static let KeyOfferHashes = "offerHashes"
    }
}
