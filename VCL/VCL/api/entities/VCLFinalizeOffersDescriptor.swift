//
//  VCLFinalizeOffersDescriptor.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//

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
        static let KeyExchangeId = "exchangeId"
        static let KeyApprovedOfferIds = "approvedOfferIds"
        static let KeyRejectedOfferIds = "rejectedOfferIds"
    }
}
