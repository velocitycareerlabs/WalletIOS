//
//  VCLCredentialManifest.swift
//  VCL
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCredentialManifest {
    public let jwt: VCLJwt
    public let vendorOriginContext: String?
    public let verifiedProfile: VCLVerifiedProfile
    
    public init(
        jwt: VCLJwt,
        vendorOriginContext: String? = nil,
        verifiedProfile: VCLVerifiedProfile
    ) {
        self.jwt = jwt
        self.vendorOriginContext = vendorOriginContext
        self.verifiedProfile = verifiedProfile
    }
    
    public var iss: String { get { return jwt.payload?[CodingKeys.KeyIss] as? String ?? "" } }
    public var did: String { get { return (jwt.payload?[CodingKeys.KeyIssuer] as? [String: String])?[CodingKeys.KeyId] ?? "" } }
    public var issuerId: String { get { return retrieveIssuerId() } }
    public var exchangeId: String { get { return jwt.payload?[CodingKeys.KeyExchangeId] as? String ?? "" } }
    public var presentationDefinitionId: String { get { (jwt.payload?[CodingKeys.KeyPresentationDefinitionId] as? [String: Any])?[CodingKeys.KeyId] as? String ?? "" } }
    
    public var finalizeOffersUri: String { get {
        (jwt.payload?[VCLCredentialManifest.CodingKeys.KeyMetadata] as? [String: Any])?[VCLCredentialManifest.CodingKeys.KeyFinalizeOffersUri] as? String ?? "" } }
    
    public var checkOffersUri: String { get {
        (jwt.payload?[VCLCredentialManifest.CodingKeys.KeyMetadata] as? [String: Any])?[VCLCredentialManifest.CodingKeys.KeyCheckOffersUri] as? String ?? "" } }

    public var submitPresentationUri: String { get {
        (jwt.payload?[VCLCredentialManifest.CodingKeys.KeyMetadata] as? [String: Any])?[VCLCredentialManifest.CodingKeys.KeySubmitIdentificationUri] as? String ?? "" } }

    private func retrieveIssuerId() -> String {
        let url = (jwt.payload?[CodingKeys.KeyMetadata] as? [String: String])?[CodingKeys.KeyFinalizeOffersUri] ?? ""
        if let range = url.range(of: "/issue/") {
            return String(url[..<range.lowerBound])
        }
        return url
    }
    
    public struct CodingKeys {
        public static let KeyIssuingRequest = "issuing_request"
        
        public static let KeyId = "id"
        public static let KeyIss = "iss"
        public static let KeyIssuer = "issuer"
        public static let KeyExchangeId = "exchange_id"
        public static let KeyPresentationDefinitionId = "presentation_definition"
        
        public static let KeyMetadata = "metadata"
        public static let KeyCheckOffersUri = "check_offers_uri"
        public static let KeyFinalizeOffersUri = "finalize_offers_uri"
        public static let KeySubmitIdentificationUri = "submit_presentation_uri"
    }
}
