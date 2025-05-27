//
//  VCLAuthToken.swift
//  VCL
//
//  Created by Michael Avoyan on 15/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLAuthToken {
    public let payload: [String: Any]
    
    public let authTokenUri: String?
    public let walletDid: String?
    public let relyingPartyDid: String?
    
    public let accessToken: VCLToken
    public let refreshToken: VCLToken
    public let tokenType: String
    
    public init(
        payload: [String: Any],
        authTokenUri: String? = nil,
        walletDid: String? = nil,
        relyingPartyDid: String? = nil
    ) {
        self.payload = payload
        
        self.authTokenUri = authTokenUri ?? payload[CodingKeys.KeyAccessTokenUri] as? String
        self.walletDid = walletDid ?? payload[CodingKeys.KeyWalletDid] as? String
        self.relyingPartyDid = relyingPartyDid ?? payload[CodingKeys.KeyRelyingPartyDid] as? String
        
        let accessTokenString = payload[CodingKeys.KeyAccessToken] as? String ?? ""
        self.accessToken = VCLToken(value: accessTokenString)
        
        let refreshTokenString = payload[CodingKeys.KeyRefreshToken] as? String ?? ""
        self.refreshToken = VCLToken(value: refreshTokenString)
        
        self.tokenType = payload[CodingKeys.KeyTokenType] as? String ?? ""
    }
    
    public enum CodingKeys {
        static let KeyAccessToken = "access_token"
        static let KeyRefreshToken = "refresh_token"
        static let KeyTokenType = "token_type"
        static let KeyAccessTokenUri = "authTokenUri"
        static let KeyWalletDid = "walletDid"
        static let KeyRelyingPartyDid = "relyingPartyDid"
    }
}

public func == (lhs: VCLAuthToken, rhs: VCLAuthToken) -> Bool {
    return lhs.accessToken == rhs.accessToken &&
    lhs.refreshToken == rhs.refreshToken &&
    lhs.tokenType == rhs.tokenType &&
    lhs.authTokenUri == rhs.authTokenUri &&
    lhs.walletDid == rhs.walletDid &&
    lhs.relyingPartyDid == rhs.relyingPartyDid
}

public func != (lhs: VCLAuthToken, rhs: VCLAuthToken) -> Bool {
    return !(lhs == rhs)
}

