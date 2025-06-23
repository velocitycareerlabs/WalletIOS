//
//  VCLCredentialManifestDescriptor.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol VCLCredentialManifestDescriptor {
    var uri: String? { get }
    var issuingType: VCLIssuingType { get }
    var credentialTypes: [String]? { get }
    var pushDelegate: VCLPushDelegate? { get }
    var did: String? { get }
    var vendorOriginContext: String? { get }
    var deepLink: VCLDeepLink? { get }
    var didJwk: VCLDidJwk { get }
    var remoteCryptoServicesToken: VCLToken? { get }
    
    var endpoint: String? { get }
    
    func retrieveEndpoint() -> String?
    
    func generateQueryParams() -> String?
    func toPropsString() -> String
}

public struct CredentialManifestDescriptorCodingKeys {
    public static let KeyDidPrefix = "did:"
    public static let KeyCredentialTypes = "credential_types"
    public static let KeyPushDelegatePushUrl = "push_delegate.push_url"
    public static let KeyPushDelegatePushToken = "push_delegate.push_token"
    
    public static let KeyCredentialId = "credentialId"
    public static let KeyRefresh = "refresh"
}

extension VCLCredentialManifestDescriptor {
    
    public var did: String? { get { return deepLink?.did } }
    
    public func retrieveEndpoint() -> String? {
        if let queryParams = generateQueryParams() {
            return self.uri?.appendQueryParams(queryParams: queryParams)
        } else {
            return self.uri
        }
    }
    
    public func generateQueryParams() -> String? {
        var pCredentialTypes: String? = nil
        var pPushDelegate: String? = nil
        var pPushToken: String? = nil
                
        if let credentialTypes = self.credentialTypes {
            pCredentialTypes = "\(credentialTypes.map{ type in "\(CredentialManifestDescriptorCodingKeys.KeyCredentialTypes)=\(type.encode() ?? "")" }.joined(separator: "&"))"
        }
        if let pushUrl = self.pushDelegate?.pushUrl {
            pPushDelegate = "\(CredentialManifestDescriptorCodingKeys.KeyPushDelegatePushUrl)=\(pushUrl.encode() ?? "")"
        }
        if let pushToken = self.pushDelegate?.pushToken {
            pPushToken = "\(CredentialManifestDescriptorCodingKeys.KeyPushDelegatePushToken)=\(pushToken.encode() ?? "")"
        }
        let qParams = [
            pCredentialTypes,
            pPushDelegate,
            pPushToken
        ].compactMap{ $0 }.filter { !$0.isEmpty }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
    
    public func toPropsString() -> String {
        var propsString = "\nuri: \(uri ?? "")"
        propsString += "\ndid: \(did ?? "")"
        propsString += "\nissuingType: \(issuingType)"
        propsString += "\ncredentialTypes: \(String(describing: credentialTypes))"
        propsString += "\npushDelegate: \(pushDelegate?.toPropsString() ?? "")"
        propsString += "\nvendorOriginContext: \(vendorOriginContext ?? "")"
        return propsString
    }
}
