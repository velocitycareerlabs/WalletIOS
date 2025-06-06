//
//  VCLFinalizeOffersDescriptor.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLFinalizeOffersDescriptor {
    public let credentialManifest: VCLCredentialManifest
    public let challenge: String?
    public let approvedOfferIds: [String]
    public let rejectedOfferIds: [String]
    
    public init(
        credentialManifest: VCLCredentialManifest,
        challenge: String? = nil,
        approvedOfferIds: [String],
        rejectedOfferIds: [String]
    ) {
        self.credentialManifest = credentialManifest
        self.challenge = challenge
        self.approvedOfferIds = approvedOfferIds
        self.rejectedOfferIds = rejectedOfferIds
    }
    
    public var payload: [String: Any?] { get {
        [
            CodingKeys.KeyExchangeId: exchangeId,
            CodingKeys.KeyApprovedOfferIds: approvedOfferIds,
            CodingKeys.KeyRejectedOfferIds: rejectedOfferIds
        ]
    } }
    public var aud: String { get { credentialManifest.aud } }
    public var issuerId: String { get { credentialManifest.issuerId } }
    public var exchangeId: String { get { credentialManifest.exchangeId } }
    public var finalizeOffersUri: String { get { credentialManifest.finalizeOffersUri } }
    public var serviceTypes: VCLServiceTypes { get { credentialManifest.verifiedProfile.serviceTypes } }
    public var didJwk: VCLDidJwk { get { credentialManifest.didJwk } }
    public var remoteCryptoServicesToken: VCLToken? { get { credentialManifest.remoteCryptoServicesToken } }
    
    func generateRequestBody(proof: VCLJwt?) -> [String: Any?] {
        var retVal = self.payload
        if let proof = proof {
            retVal[CodingKeys.KeyProof] = [
                CodingKeys.KeyProofType: CodingKeys.KeyJwt,
                CodingKeys.KeyJwt: proof.encodedJwt
            ]
        }
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
