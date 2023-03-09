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
    public let didJwk: VCLDidJwk
    public let challenge: String
    public let credentialManifest: VCLCredentialManifest
    public let approvedOfferIds: [String]
    public let rejectedOfferIds: [String]
    
    public init(
        didJwk: VCLDidJwk,
        challenge: String,
        credentialManifest: VCLCredentialManifest,
        approvedOfferIds: [String],
        rejectedOfferIds: [String]
    ) {
        self.didJwk = didJwk
        self.challenge = challenge
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
    
    var issuerId: String { get { credentialManifest.issuerId } }
    var exchangeId: String { get { credentialManifest.exchangeId } }
    var finalizeOffersUri: String { get { credentialManifest.finalizeOffersUri } }
    
    public func generateRequestBody(jwt: VCLJwt) -> [String: Any?] {
        var retVal = self.payload
        retVal[CodingKeys.KeyProof] = [
            CodingKeys.KeyProofType: CodingKeys.KeyJwt,
            CodingKeys.KeyJwt: jwt.encodedJwt
        ]
        return retVal
    }
    
    public struct CodingKeys {
        public static let KeyExchangeId = "exchangeId"
        public static let KeyApprovedOfferIds = "approvedOfferIds"
        public static let KeyRejectedOfferIds = "rejectedOfferIds"
        
        public static let KeyJwt = "jwt"
        public static let KeyProof = "proof"
        public static let KeyProofType = "proof_type"
    }
}
