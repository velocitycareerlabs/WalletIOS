//
//  VCLFinalizeOffersDescriptor.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLFinalizeOffersDescriptor {
    public let credentialManifest: VCLCredentialManifest
    public let approvedOfferIds: [String]
    public let rejectedOfferIds: [String]
    
    public init(credentialManifest: VCLCredentialManifest,
                approvedOfferIds: [String],
                rejectedOfferIds: [String]) {
        self.credentialManifest = credentialManifest
        self.approvedOfferIds = approvedOfferIds
        self.rejectedOfferIds = rejectedOfferIds
    }
    
    var payload: [String: Any?] { get {
        [
            CodingKeys.KeyExchangeId: exchangeId,
            CodingKeys.KeyApprovedOfferIds: approvedOfferIds,
            CodingKeys.KeyRejectedOfferIds: rejectedOfferIds
        ]
    } }
    
    var did: String { get { credentialManifest.did } }
    var exchangeId: String { get { credentialManifest.exchangeId } }
    
    var finalizeOffersUri: String { get { credentialManifest.finalizeOffersUri } }
    
    public struct CodingKeys {
        public static let KeyExchangeId = "exchangeId"
        public static let KeyApprovedOfferIds = "approvedOfferIds"
        public static let KeyRejectedOfferIds = "rejectedOfferIds"
    }
}
