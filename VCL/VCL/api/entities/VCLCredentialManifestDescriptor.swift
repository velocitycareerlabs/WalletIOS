//
//  VCLCredentialManifestDescriptor.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLCredentialManifestDescriptor {
    public let uri: String?
    public let issuingType: VCLIssuingType
    public let credentialTypes: [String]?
    public let pushDelegate: VCLPushDelegate?
    public let did: String?
    public let vendorOriginContext: String?
    public let deepLink: VCLDeepLink?
    public let didJwk: VCLDidJwk?
    public let remoteCryptoServicesToken: VCLToken?
    
    public init(
        uri: String?,
        issuingType: VCLIssuingType = VCLIssuingType.Career,
        credentialTypes: [String]? = nil,
        pushDelegate: VCLPushDelegate? = nil,
        vendorOriginContext: String? = nil,
        deepLink: VCLDeepLink? = nil,
        didJwk: VCLDidJwk? = nil,
        remoteCryptoServicesToken: VCLToken? = nil
    ) {
        self.uri = uri
        self.issuingType = issuingType
        self.credentialTypes = credentialTypes
        self.pushDelegate = pushDelegate
        self.did = uri?.getUrlSubPath(subPathPrefix: CodingKeys.KeyDidPrefix)
        self.vendorOriginContext = vendorOriginContext
        self.deepLink = deepLink
        self.didJwk = didJwk
        self.remoteCryptoServicesToken = remoteCryptoServicesToken
    }
    
    public var endpoint: String? { get {
        if let queryParams = generateQueryParams() {
            return self.uri?.appendQueryParams(queryParams: queryParams)
        } else {
            return self.uri
        }
    }}
    
    func generateQueryParams() -> String? {
        var pCredentialTypes: String? = nil
        var pPushDelegate: String? = nil
        var pPushToken: String? = nil
                
        if let credentialTypes = self.credentialTypes {
            pCredentialTypes = "\(credentialTypes.map{ type in "\(CodingKeys.KeyCredentialTypes)=\(type.encode() ?? "")" }.joined(separator: "&"))"
        }
        if let pushUrl = self.pushDelegate?.pushUrl {
            pPushDelegate = "\(CodingKeys.KeyPushDelegatePushUrl)=\(pushUrl.encode() ?? "")"
        }
        if let pushToken = self.pushDelegate?.pushToken {
            pPushToken = "\(CodingKeys.KeyPushDelegatePushToken)=\(pushToken.encode() ?? "")"
        }
        let qParams = [
            pCredentialTypes,
            pPushDelegate,
            pPushToken
        ].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
    
    open func toPropsString() -> String {
        var propsString = ""
        propsString += "\nuri: \(uri ?? "")"
        propsString += "\ndid: \(did ?? "")"
        propsString += "\nissuingType: \(issuingType)"
        propsString += "\ncredentialTypes: \(String(describing: credentialTypes))"
        propsString += "\npushDelegate: \(pushDelegate?.toPropsString() ?? "")"
        propsString += "\nvendorOriginContext: \(vendorOriginContext ?? "")"
        return propsString
    }
    
    public struct CodingKeys {
        public static let KeyDidPrefix = "did:"
        public static let KeyCredentialTypes = "credential_types"
        public static let KeyPushDelegatePushUrl = "push_delegate.push_url"
        public static let KeyPushDelegatePushToken = "push_delegate.push_token"
        
        public static let KeyCredentialId = "credentialId"
        public static let KeyRefresh = "refresh"
    }
}
