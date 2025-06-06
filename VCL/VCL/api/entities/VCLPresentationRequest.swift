//
//  VCLPresentationRequest.swift
//  
//
//  Created by Michael Avoyan on 01/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLPresentationRequest {
    public let jwt: VCLJwt
    public let verifiedProfile: VCLVerifiedProfile
    public let deepLink: VCLDeepLink
    public let pushDelegate: VCLPushDelegate?
    public let didJwk: VCLDidJwk
    public let remoteCryptoServicesToken: VCLToken?
    public let feed: Bool
    public let vendorOriginContext: String?
    
    public init(
        jwt: VCLJwt,
        verifiedProfile: VCLVerifiedProfile,
        deepLink: VCLDeepLink,
        pushDelegate: VCLPushDelegate? = nil,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.jwt = jwt
        self.verifiedProfile = verifiedProfile
        self.deepLink = deepLink
        self.pushDelegate = pushDelegate
        self.didJwk = didJwk
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
        self.vendorOriginContext = deepLink.vendorOriginContext
        self.feed = (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Any])?[CodingKeys.KeyFeed] as? Bool ?? false
    }
    
    public var iss: String { get { jwt.payload?[CodingKeys.KeyIss] as? String ?? "" } }
    public var exchangeId: String { get { jwt.payload?[CodingKeys.KeyExchangeId] as? String ?? "" } }
    public var presentationDefinitionId: String { get {
        (jwt.payload?[CodingKeys.KeyPresentationDefinition] as? [String: Any])? [CodingKeys.KeyId] as? String ?? "" }
    }
    var keyID: String { get { return jwt.header?["kid"] as? String ?? "" } }
    
    var progressUri: String { get {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Any])?[CodingKeys.KeyProgressUri] as? String ?? "" } }
    var submitPresentationUri: String { get {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Any])?[CodingKeys.KeySubmitPresentationUri] as? String ?? "" } }
    
    var authTokenUri: String {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Any])?[CodingKeys.KeyAuthTokenUri] as? String ?? ""
    }

    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyIss = "iss"
        public static let KeyPresentationRequest = "presentation_request"
        public static let KeyExchangeId = "exchange_id" // for presentationDefinitionId value
        public static let KeyPresentationDefinition = "presentation_definition"
        
        public static let KeyMetadata = "metadata"
        public static let KeyProgressUri = "progress_uri"
        public static let KeySubmitPresentationUri = "submit_presentation_uri"
        public static let KeyFeed = "feed"
        public static let KeyAuthTokenUri = "auth_token_uri"
    }
}
