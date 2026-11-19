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
    
    // The link's query is read before anything is decoded, so the request URI's own query stays apart: a repeated
    // name such as credential_types keeps every value, and a value keeps any &, = or ? it encodes. The link's other
    // parameters are added to the request URI and replace any it carries under the same name.
    private func generateUri(uriKey: String) -> String? {
        let linkItems = value.getUrlQueryItems()
        guard let uri = linkItems.last(where: { $0.name == uriKey })?.value else {
            return nil
        }
        let linkParams = linkItems.filter { $0.name != uriKey }
        let linkNames = Set<String>(linkParams.map { $0.name })
        let uriParams = uri.getUrlQueryItems(lenient: true).filter { linkNames.contains($0.name) == false }
        let params = (uriParams + linkParams).filter { $0.value.isEmpty == false }
        if params.isEmpty {
            return uri
        }
        let query: String = params
            .map { "\($0.name.encodeQueryComponent())=\($0.value.encodeQueryComponent())" }
            .joined(separator: "&")
        return "\(uri.prefix(while: { $0 != "?" }))?\(query)"
    }

    // The link's own parameter, else one inside a URL the link carries, such as request_uri or an OpenID issuer
    private func retrieveQueryParam(key: String) -> String? {
        let linkItems = value.getUrlQueryItems()
        if let item = linkItems.last(where: { $0.name == key }) {
            return item.value
        }
        for item in linkItems.reversed() {
            if let nested = item.value.getUrlQueryParams()?[key] {
                return nested
            }
        }
        return nil
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
