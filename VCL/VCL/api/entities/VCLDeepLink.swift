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
    
    public var requestUri: String { get {
        return generateRequestUri()
    } }
    
    public var vendorOriginContext: String? { get {
        self.value.getUrlQueryParams()?[CodingKeys.KeyVendorOriginContext]?.decode()
    }}
    
    private func generateRequestUri() -> String {
        var resRequestUri = ""
        if let queryParams = self.value.getUrlQueryParams() {
            resRequestUri = queryParams[CodingKeys.KeyRequestUri] ?? ""
            let queryItems = queryParams
                .map { (key, value) in (key, value.encode()) }
                .filter { (key, value) in key != CodingKeys.KeyRequestUri && value?.isEmpty == false }
                .map {(key, value) in "\(key)=\(value ?? "")" }
                .sorted() // Sort is needed for unit tests
                .joined(separator: "&")
            if queryItems.isEmpty == false {
                resRequestUri += "&\(queryItems)"
            }
        }
        return resRequestUri
    }
    
    private func retrieveVendorOriginContext() -> String? {
        return self.value.decode()?.getUrlQueryParams()?[CodingKeys.KeyVendorOriginContext]
    }
    
    public struct CodingKeys {
        static let KeyRequestUri = "request_uri"
        static let KeyVendorOriginContext = "vendorOriginContext"
    }
}
