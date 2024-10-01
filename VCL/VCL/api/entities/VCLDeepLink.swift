//
//  VCLDeepLink.swift
//  VCL
//
//  Created by Michael Avoyan on 08/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLDeepLink: Sendable {
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
        (retrieveQueryParam(key: CodingKeys.KeyIssuerDid) ?? retrieveQueryParam(key: CodingKeys.KeyInspectorDid)) ??
        requestUri?.getUrlSubPath(subPathPrefix: CodingKeys.KeyDidPrefix) // fallback for old agents
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
    
    public struct CodingKeys {
        public static let KeyDidPrefix = "did:"
        public static let KeyRequestUri = "request_uri"
        public static let KeyVendorOriginContext = "vendorOriginContext"
        public static let KeyIssuerDid = "issuerDid"
        public static let KeyInspectorDid = "inspectorDid"
    }
}
