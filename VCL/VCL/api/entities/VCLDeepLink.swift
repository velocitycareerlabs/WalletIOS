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
    
    // The dictionary keeps one value per key, so credential_types, which a link repeats once per type, comes with
    // every value from the request URI's own query instead. The request URI is taken from the link before the rest
    // is decoded, so text encoded in another value can't add a type. A request URI without credential_types of its
    // own is handled as before.
    private func generateUri(uriKey: String, asSubParams: Bool = false) -> String? {
        if let queryParams = self.value.decode()?.getUrlQueryParams() {
            if let uri = queryParams[uriKey] {
                let credentialTypesKey = CredentialManifestDescriptorCodingKeys.KeyCredentialTypes
                let requestUriCredentialTypes: [String] = rawQueryParam(key: uriKey)?.decode()?
                    .getUrlQueryParamValues(key: credentialTypesKey) ?? []
                var credentialTypes: [String] = []
                for credentialType in requestUriCredentialTypes
                    where credentialType.isEmpty == false && credentialTypes.contains(credentialType) == false {
                    credentialTypes.append(credentialType)
                }
                let otherItems: [String] = queryParams
                    .filter { (key, value) in
                        key != uriKey && value.isEmpty == false &&
                            (credentialTypes.isEmpty || key != credentialTypesKey)
                    }
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
    
    // A parameter of the link as it's written, before anything is decoded
    private func rawQueryParam(key: String) -> String? {
        guard let start: String.Index = value.firstIndex(of: "?") else {
            return nil
        }
        let params: [Substring] = value[value.index(after: start)...].split(separator: "&")
        guard let param: Substring = params.last(where: { $0.prefix(while: { char in char != "=" }) == key }),
              let separator: Substring.Index = param.firstIndex(of: "=")
        else {
            return nil
        }
        return String(param[param.index(after: separator)...])
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
