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
    public let jwt: VCLJWT
    public let vendorOriginContext: String?
    
    public init(jwt: VCLJWT, vendorOriginContext: String? = nil) {
        self.jwt = jwt
        self.vendorOriginContext = vendorOriginContext
    }
    
    public var iss: String { get { return jwt.payload?[CodingKeys.KeyIss] as? String ?? "" } }
    public var did: String { get { return (jwt.payload?[CodingKeys.KeyIssuer] as? [String: String])?[CodingKeys.KeyId] ?? "" } }
    public var exchangeId: String { get { return jwt.payload?[CodingKeys.KeyExchangeId] as? String ?? "" } }
    public var presentationDefinitionId: String { get { (jwt.payload?[CodingKeys.KeyPresentationDefinitionId] as? [String: Any])?[CodingKeys.KeyId] as? String ?? "" } }
    
    public var finalizeOffersUri: String { get {
        (jwt.payload?[VCLCredentialManifest.CodingKeys.KeyMetadata] as? [String: Any])?[VCLCredentialManifest.CodingKeys.KeyFinalizeOffersUri] as? String ?? "" } }
    
    public var checkOffersUri: String { get {
        (jwt.payload?[VCLCredentialManifest.CodingKeys.KeyMetadata] as? [String: Any])?[VCLCredentialManifest.CodingKeys.KeyCheckOffersUri] as? String ?? "" } }

    public var submitPresentationUri: String { get {
        (jwt.payload?[VCLCredentialManifest.CodingKeys.KeyMetadata] as? [String: Any])?[VCLCredentialManifest.CodingKeys.KeySubmitIdentificationUri] as? String ?? "" } }

    struct CodingKeys {
        static let KeyIssuingRequest = "issuing_request"
        
        static let KeyId = "id"
        static let KeyIss = "iss"
        static let KeyIssuer = "issuer"
        static let KeyExchangeId = "exchange_id"
        static let KeyPresentationDefinitionId = "presentation_definition"
        
        static let KeyMetadata = "metadata"
        static let KeyCheckOffersUri = "check_offers_uri"
        static let KeyFinalizeOffersUri = "finalize_offers_uri"
        static let KeySubmitIdentificationUri = "submit_presentation_uri"
    }
}
