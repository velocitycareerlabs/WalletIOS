//
//  VCLDeepLink.swift
//  VCL
//
//  Created by Michael Avoyan on 08/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLDeepLink {
    public let value: String
    
    public init(value: String) {
        self.value = value
    }

    public var requestUri: String? { get {
        return generateUri(uriKey: CodingKeys.KeyRequestUri)
    } }
    
    public var vendorOriginContext: String? { get {
        self.retrieveQueryParam(key: CodingKeys.KeyVendorOriginContext)
    }}
    
    public var did: String? { get{
        let topLevelIssuerDid = topLevelQueryParam(key: CodingKeys.KeyIssuerDid)
        let topLevelInspectorDid = topLevelQueryParam(key: CodingKeys.KeyInspectorDid)
        let requestUriParams = requestUri?.decode()?.getUrlQueryParams()
        let requestUriIssuerDid = requestUriParams?[CodingKeys.KeyIssuerDid]
        let requestUriInspectorDid = requestUriParams?[CodingKeys.KeyInspectorDid]
        let decodedIssuerDid = retrieveQueryParam(key: CodingKeys.KeyIssuerDid)
        let decodedInspectorDid = retrieveQueryParam(key: CodingKeys.KeyInspectorDid)
        let didSubPath = requestUri?.getUrlSubPath(subPathPrefix: CodingKeys.KeyDidPrefix)
        
        return topLevelIssuerDid ??
            topLevelInspectorDid ??
            requestUriIssuerDid ??
            requestUriInspectorDid ??
            decodedIssuerDid ??
            decodedInspectorDid ??
            didSubPath // fallback for old agents
    } }
    
    // The dictionary keeps one value per key, so credential_types, which a link repeats once per type, is added
    // with every value instead
    private func generateUri(uriKey: String, asSubParams: Bool = false) -> String? {
        if let decodedValue = self.value.decode(), let queryParams = decodedValue.getUrlQueryParams() {
            if let uri = queryParams[uriKey] {
                let credentialTypesKey = CredentialManifestDescriptorCodingKeys.KeyCredentialTypes
                var credentialTypes: [String] = []
                for credentialType in decodedValue.getUrlQueryParamValues(key: credentialTypesKey)
                    where credentialType.isEmpty == false && credentialTypes.contains(credentialType) == false {
                    credentialTypes.append(credentialType)
                }
                let otherItems: [String] = queryParams
                    .filter { (key, value) in key != uriKey && key != credentialTypesKey && value.isEmpty == false }
                    .map { (key, value) in "\(key)=\(value.encode() ?? "")" }
                let credentialTypeItems: [String] = credentialTypes
                    .map { (credentialType: String) -> String in "\(credentialTypesKey)=\(credentialType.encode() ?? "")" }
                let queryItems = (otherItems + credentialTypeItems).joined(separator: "&")
                if queryItems.isEmpty == false {
                    return asSubParams ? "\(uri)&\(queryParams)" : uri.appendQueryParams(queryParams: queryItems)
                }
                return uri
            }
        }
        return nil
    }
    
    private func retrieveQueryParam(key: String) -> String? {
        return self.value.decode()?.getUrlQueryParams()?[key]
    }
    
    private func topLevelQueryParam(key: String) -> String? {
        guard
            let components = URLComponents(string: value),
            let queryItems = components.queryItems
        else {
            return nil
        }
        return queryItems.last { $0.name == key }?.value
    }
    
    public struct CodingKeys {
        public static let KeyDidPrefix = "did:"
        public static let KeyRequestUri = "request_uri"
        public static let KeyVendorOriginContext = "vendorOriginContext"
        public static let KeyIssuerDid = "issuerDid"
        public static let KeyInspectorDid = "inspectorDid"
    }
}
