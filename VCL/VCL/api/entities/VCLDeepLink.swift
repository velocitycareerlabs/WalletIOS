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
    
    public var did: String? { get{
        if let did = requestUri?.getUrlSubPath(subPathPrefix: CodingKeys.KeyDidPrefix) {
            return did
        }
        return issuer?.getUrlSubPath(subPathPrefix: CodingKeys.KeyDidPrefix)
    } }
    public var issuer: String? { get {
        return generateUri(uriKey: CodingKeys.KeyIssuer)
    } }

    public var requestUri: String? { get {
        return generateUri(uriKey: CodingKeys.KeyRequestUri)
    } }
    
    public var vendorOriginContext: String? { get {
        self.value.decode()?.getUrlQueryParams()?[CodingKeys.KeyVendorOriginContext]
    }}
    
    private func generateUri(uriKey: String, asSubParams: Bool = false) -> String? {
        if let queryParams = self.value.decode()?.getUrlQueryParams() {
            if let uri = queryParams[uriKey] {
                let queryItems = queryParams
                    .filter { (key, value) in key != uriKey && value.isEmpty == false }
                    .map {(key, value) in "\(key)=\(value.encode() ?? "")" }
                    .sorted() // Sort is needed for unit tests
                    .joined(separator: "&")
                if queryItems.isEmpty == false {
                    return asSubParams ? "\(uri)&\(queryParams)" : uri.appendQueryParams(queryParams: queryItems)
                }
                return uri
            }
        }
        return nil
    }
    
    private func retrieveVendorOriginContext() -> String? {
        return self.value.decode()?.getUrlQueryParams()?[CodingKeys.KeyVendorOriginContext]
    }
    
    public struct CodingKeys {
        public static let KeyDidPrefix = "did:"
        public static let KeyIssuer = "issuer"
        public static let KeyRequestUri = "request_uri"
        public static let KeyVendorOriginContext = "vendorOriginContext"
    }
}
