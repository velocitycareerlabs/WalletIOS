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
    
    // Decoding the link merges the request URI's own query into the link's, so the query is read as a list:
    // a dictionary would keep one of a request URI's repeated credential_types. A pair that both carry,
    // such as issuerDid, is sent once.
    private func generateUri(uriKey: String, asSubParams: Bool = false) -> String? {
        guard
            let queryParams = self.value.decode()?.getUrlQueryParamList(),
            let uri = queryParams.last(where: { $0.key == uriKey })?.value
        else {
            return nil
        }
        var sent = Set<String>()
        let queryItems = queryParams
            .filter { $0.key != uriKey && $0.value.isEmpty == false }
            .map { "\($0.key)=\($0.value.encode() ?? "")" }
            .filter { sent.insert($0).inserted }
            .joined(separator: "&")
        if queryItems.isEmpty == false {
            return asSubParams ? "\(uri)&\(queryItems)" : uri.appendQueryParams(queryParams: queryItems)
        }
        return uri
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
