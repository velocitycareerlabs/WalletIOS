//
//  VCLDeepLink.swift
//  VCL
//
//  Created by Michael Avoyan on 08/08/2021.
//

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
    
    struct CodingKeys {
        static let KeyPresentationRequestPrefix = "velocity-network://inspect?request_uri="
        static let KeyCredentialManifestPrefix = "velocity-network://issue?request_uri="

        static let KeyRequestUri = "request_uri"
        static let KeyVendorOriginContext = "vendorOriginContext"
    }
}
