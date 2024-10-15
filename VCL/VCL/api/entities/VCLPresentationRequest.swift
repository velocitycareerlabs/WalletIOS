//
//  VCLPresentationRequest.swift
//  
//
//  Created by Michael Avoyan on 01/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLPresentationRequest: Sendable {
    public let jwt: VCLJwt
    public let verifiedProfile: VCLVerifiedProfile
    public let deepLink: VCLDeepLink
    public let pushDelegate: VCLPushDelegate?
    public let didJwk: VCLDidJwk
    public let remoteCryptoServicesToken: VCLToken?
    
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
    }
    
    public var iss: String { get { jwt.payload?[CodingKeys.KeyIss] as? String ?? "" } }
    public var exchangeId: String { get { jwt.payload?[CodingKeys.KeyExchangeId] as? String ?? "" } }
    public var presentationDefinitionId: String { get {
        (jwt.payload?[CodingKeys.KeyPresentationDefinition] as? [String: Sendable])? [CodingKeys.KeyId] as? String ?? "" }
    }
    var keyID: String { get { return jwt.header?["kid"] as? String ?? "" } }
    var vendorOriginContext: String? { get { deepLink.vendorOriginContext } }
    
    var progressUri: String { get {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Sendable])?[CodingKeys.KeyProgressUri] as? String ?? "" } }
    var submitPresentationUri: String { get {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Sendable])?[CodingKeys.KeySubmitPresentationUri] as? String ?? "" } }
    
    public struct CodingKeys {
        public static let KeyId = "id"
        public static let KeyIss = "iss"
        public static let KeyPresentationRequest = "presentation_request"
        public static let KeyExchangeId = "exchange_id" // for presentationDefinitionId value
        public static let KeyPresentationDefinition = "presentation_definition"
        
        public static let KeyMetadata = "metadata"
        public static let KeyProgressUri = "progress_uri"
        public static let KeySubmitPresentationUri = "submit_presentation_uri"
    }
}
