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
        let requestUriItems = requestUri?.getUrlQueryItems(lenient: true) ?? []
        let requestUriIssuerDid = requestUriItems.last(where: { $0.name == CodingKeys.KeyIssuerDid })?.value
        let requestUriInspectorDid = requestUriItems.last(where: { $0.name == CodingKeys.KeyInspectorDid })?.value
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
    
    // The link's query is split before anything is decoded, so the request URI's own query stays apart. The request
    // URI keeps its query items as the issuer wrote them and gets the link's other parameters as the link wrote them,
    // so a repeated name such as credential_types keeps every value and no value is decoded and encoded again. A link
    // parameter replaces any the request URI carries under the same name. Characters a URL can't hold are escaped.
    // A link whose escapes don't decode gives no request URI, as before.
    private func generateUri(uriKey: String) -> String? {
        guard value.removingPercentEncoding != nil else {
            return nil
        }
        let linkSegments: [String] = value.getUrlQuerySegments()
        guard
            let uriSegment: String = linkSegments.last(where: { $0.segmentName == uriKey }),
            let uri: String = uriSegment.segmentValue.removingPercentEncoding
        else {
            return nil
        }
        let linkParams: [String] = linkSegments.filter { $0.segmentName != uriKey }
        let linkNames = Set<String>(linkParams.map { $0.segmentName })
        let uriParams: [String] = uri.getUrlQuerySegments().filter { linkNames.contains($0.segmentName) == false }
        let params: [String] = (uriParams + linkParams)
            .filter { $0.segmentValue.isEmpty == false }
            .map { $0.encodeIllegalQueryCharacters() }
        let base = String(uri.prefix(while: { $0 != "?" }))
        return params.isEmpty ? base : "\(base)?\(params.joined(separator: "&"))"
    }

    // The link's own parameter, else one in the query of a URL the link carries, such as request_uri or an OpenID
    // issuer. Other values, such as vendorOriginContext, aren't read as queries.
    private func retrieveQueryParam(key: String) -> String? {
        let linkItems = value.getUrlQueryItems()
        if let item = linkItems.last(where: { $0.name == key }) {
            return item.value
        }
        for item in linkItems.reversed() {
            if let nested = item.value.urlQueryValue(key: key) {
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

private extension String {
    // A query item's name, decoded, or as it is when its escapes don't decode
    var segmentName: String {
        let name = String(self.prefix(while: { $0 != "=" }))
        return name.removingPercentEncoding ?? name
    }

    // A query item's value as it's written
    var segmentValue: String {
        guard let separator: String.Index = self.firstIndex(of: "=") else {
            return ""
        }
        return String(self[self.index(after: separator)...])
    }

    // The parameter in this value's query when the value is a URL, read as the request URI is built and decoded once,
    // so it matches what's sent. A URL that starts its query with & instead of ?, as some OpenID issuer links do, is
    // read the same way.
    func urlQueryValue(key: String) -> String? {
        guard self.range(of: "^[A-Za-z][A-Za-z0-9+.-]*://", options: .regularExpression) != nil else {
            return nil
        }
        let query: Substring
        if let question: String.Index = self.firstIndex(of: "?") {
            query = self[self.index(after: question)...]
        } else if let ampersand: String.Index = self.firstIndex(of: "&") {
            query = self[self.index(after: ampersand)...]
        } else {
            return nil
        }
        let segments: [String] = query.prefix(while: { char in char != "#" })
            .split(separator: "&")
            .map { (part: Substring) -> String in String(part) }
        guard let segment: String = segments.last(where: { $0.segmentName == key }) else {
            return nil
        }
        return segment.segmentValue.removingPercentEncoding ?? segment.segmentValue
    }
}
