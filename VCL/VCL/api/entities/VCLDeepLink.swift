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
    
    private func generateUri(uriKey: String, asSubParams: Bool = false) -> String? {
        if let queryParams = self.value.decode()?.getUrlQueryParams() {
            if let uri = queryParams[uriKey] {
                let queryItems = queryParams
                    .filter { (key, value) in key != uriKey && value.isEmpty == false }
                    .map {(key, value) in "\(key)=\(value.encode() ?? "")" }
                    .joined(separator: "&")
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
