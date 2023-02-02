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
    public let jwkPublic: VCLJwkPublic
    public let deepLink: VCLDeepLink
    public let pushDelegate: VCLPushDelegate?
    
    public init(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        deepLink: VCLDeepLink,
        pushDelegate: VCLPushDelegate? = nil
    ) {
        self.jwt = jwt
        self.jwkPublic = jwkPublic
        self.deepLink = deepLink
        self.pushDelegate = pushDelegate
    }
    
    public var iss: String { get { jwt.payload?[CodingKeys.KeyIss] as? String ?? "" } }
    public var exchangeId: String { get { jwt.payload?[CodingKeys.KeyExchangeId] as? String ?? "" } }
    public var presentationDefinitionId: String { get {
        (jwt.payload?[CodingKeys.KeyPresentationDefinition] as? [String:Any])? [CodingKeys.KeyId] as? String ?? "" }
    }
    var keyID: String { get { return jwt.header?["kid"] as? String ?? "" } }
    var vendorOriginContext: String? { get { deepLink.vendorOriginContext } }
    
    var progressUri: String { get {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Any])?[CodingKeys.KeyProgressUri] as? String ?? "" } }
    var submitPresentationUri: String { get {
        (jwt.payload?[CodingKeys.KeyMetadata] as? [String: Any])?[CodingKeys.KeySubmitPresentationUri] as? String ?? "" } }
    
    public struct CodingKeys {
        static let KeyId = "id"
        static let KeyIss = "iss"
        static let KeyPresentationRequest = "presentation_request"
        static let KeyExchangeId = "exchange_id" // for presentationDefinitionId value
        static let KeyPresentationDefinition = "presentation_definition"
        
        static let KeyMetadata = "metadata"
        static let KeyProgressUri = "progress_uri"
        static let KeySubmitPresentationUri = "submit_presentation_uri"
    }
}
