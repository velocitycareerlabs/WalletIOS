//
//  VCLAuthTokenDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 15/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum GrantType: String {
    case AuthorizationCode = "authorization_code"
    case RefreshToken = "refresh_token"
}

public struct VCLAuthTokenDescriptor {
    public let authTokenUri: String
    public let refreshToken: VCLToken?
    public let walletDid: String?
    public let relyingPartyDid: String?
    public let authorizationCode: String?
    
    public init(
        authTokenUri: String,
        refreshToken: VCLToken? = nil,
        walletDid: String? = nil,
        relyingPartyDid: String? = nil,
        authorizationCode: String? = nil
    ) {
        self.authTokenUri = authTokenUri
        self.refreshToken = refreshToken
        self.walletDid = walletDid
        self.relyingPartyDid = relyingPartyDid
        self.authorizationCode = authorizationCode
    }
    
    public init(presentationRequest: VCLPresentationRequest, refreshToken: VCLToken? = nil) {
        self.authTokenUri = presentationRequest.authTokenUri
        self.refreshToken = refreshToken
        self.walletDid = presentationRequest.didJwk.did
        self.relyingPartyDid = presentationRequest.iss
        self.authorizationCode = presentationRequest.vendorOriginContext
    }
    
    func generateRequestBody() -> [String: String?] {
        if let refreshToken = refreshToken {
            return [
                CodingKeys.KeyGrantType: GrantType.RefreshToken.rawValue,
                CodingKeys.KeyClientId: walletDid,
                GrantType.RefreshToken.rawValue: refreshToken.value,
                CodingKeys.KeyAudience: relyingPartyDid
            ]
        } else {
            return [
                CodingKeys.KeyGrantType: GrantType.AuthorizationCode.rawValue,
                CodingKeys.KeyClientId: walletDid,
                GrantType.AuthorizationCode.rawValue: authorizationCode,
                CodingKeys.KeyAudience: relyingPartyDid,
                CodingKeys.KeyTokenType: CodingKeys.KeyTokenTypeValue
            ]
        }
    }
    
    enum CodingKeys {
        static let KeyClientId = "client_id"
        static let KeyAudience = "audience"
        static let KeyGrantType = "grant_type"
        static let KeyTokenType = "token_type"
        static let KeyTokenTypeValue = "Bearer"
    }
}
