//
//  VelocityDeepLinkValidator.swift
//  VCL
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class VelocityDeepLinkValidator {
    static let sourceUnparseablePayload = "invalid_link_unparseable_payload"
    static let sourceUnsupportedVelocityLink = "invalid_link_unsupported_velocity_link"
    static let sourceInvalidOrMissingDid = "invalid_link_invalid_or_missing_did"
    static let sourceInvalidOrMissingRequestUri = "invalid_link_invalid_or_missing_request_uri"
    static let sourceInvalidOrMissingRequestEndpoint = "invalid_link_invalid_or_missing_request_endpoint"
    
    private static let allowedVelocitySchemes = [
        "velocity-network",
        "velocity-network-devnet",
        "velocity-network-testnet"
    ]
    
    func validateDeepLink(
        _ deepLink: VCLDeepLink,
        expectedPath: String,
        requestKind: String
    ) -> VCLError? {
        guard let components = URLComponents(string: deepLink.value),
              let scheme = components.scheme,
              let host = components.host
        else {
            return ErrorTaxonomy.invalidLink(
                message: "Payload is not a parseable URL",
                sourceErrorCode: Self.sourceUnparseablePayload,
                requestUri: deepLink.requestUri,
                requestKind: requestKind
            )
        }
        
        guard Self.allowedVelocitySchemes.contains(scheme), host == expectedPath else {
            return ErrorTaxonomy.invalidLink(
                message: "Unsupported Velocity link: \(deepLink.value)",
                sourceErrorCode: Self.sourceUnsupportedVelocityLink,
                requestUri: deepLink.requestUri,
                requestKind: requestKind
            )
        }
        
        guard Self.isValidDid(deepLink.did) else {
            return ErrorTaxonomy.invalidLink(
                message: "Invalid or missing DID in Velocity link",
                sourceErrorCode: Self.sourceInvalidOrMissingDid,
                requestUri: deepLink.requestUri,
                requestKind: requestKind
            )
        }
        
        guard Self.isValidRequestUri(deepLink.requestUri) else {
            return ErrorTaxonomy.invalidLink(
                message: "Invalid or missing request_uri in Velocity link",
                sourceErrorCode: Self.sourceInvalidOrMissingRequestUri,
                requestUri: deepLink.requestUri,
                requestKind: requestKind
            )
        }
        
        return nil
    }
    
    func validateRequestEndpoint(requestUri: String?, requestKind: String) -> VCLError? {
        guard let requestUri = requestUri, Self.isValidRequestUri(requestUri) else {
            return ErrorTaxonomy.invalidLink(
                message: "Invalid or missing request endpoint",
                sourceErrorCode: Self.sourceInvalidOrMissingRequestEndpoint,
                requestUri: requestUri,
                requestKind: requestKind
            )
        }
        return nil
    }
    
    private static func isValidRequestUri(_ requestUri: String?) -> Bool {
        guard let requestUri = requestUri else {
            return false
        }
        guard let components = URLComponents(string: requestUri),
              let scheme = components.scheme?.lowercased(),
              components.host != nil
        else {
            return false
        }
        return scheme == "http" || scheme == "https"
    }
    
    private static func isValidDid(_ did: String?) -> Bool {
        guard let did = did, did.hasPrefix(VCLDeepLink.CodingKeys.KeyDidPrefix) else {
            return false
        }
        let didParts = String(did.dropFirst(VCLDeepLink.CodingKeys.KeyDidPrefix.count))
        guard let methodEndIndex = didParts.firstIndex(of: ":"),
              methodEndIndex > didParts.startIndex,
              methodEndIndex < didParts.index(before: didParts.endIndex) else {
            return false
        }
        let method = didParts[..<methodEndIndex]
        return method.unicodeScalars.allSatisfy {
            ($0.value >= 97 && $0.value <= 122) || ($0.value >= 48 && $0.value <= 57)
        }
    }
}
