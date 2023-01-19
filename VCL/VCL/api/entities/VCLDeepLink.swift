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
    
    public var issuer: String? { get {
        return generateUri(uriKey: CodingKeys.KeyIssuer, asSubParams: true)
    } }

    public var requestUri: String? { get {
        return generateUri(uriKey: CodingKeys.KeyRequestUri)
    } }
    
    public var vendorOriginContext: String? { get {
        self.value.getUrlQueryParams()?[CodingKeys.KeyVendorOriginContext]?.decode()
    }}
    
    private func generateUri(uriKey: String, asSubParams: Bool = false) -> String? {
        if let queryParams = self.value.getUrlQueryParams() {
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
        static let KeyIssuer = "issuer"
        static let KeyRequestUri = "request_uri"
        static let KeyVendorOriginContext = "vendorOriginContext"
    }
}
