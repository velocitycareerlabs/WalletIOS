//
//  PublicRequestDescriptorValidator.swift
//  VCL
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class PublicRequestDescriptorValidator {
    private let config: Config
    private let deepLinkValidator: VelocityDeepLinkValidator
    
    init(config: Config, deepLinkValidator: VelocityDeepLinkValidator = VelocityDeepLinkValidator()) {
        self.config = config
        self.deepLinkValidator = deepLinkValidator
    }
    
    func validate(_ descriptor: VCLPresentationRequestDescriptor) -> VCLError? {
        validate(
            PublicRequestDescriptor(
                deepLink: descriptor.deepLink,
                endpoint: descriptor.endpoint,
                did: descriptor.did,
                description: "\(descriptor)"
            )
        )
    }
    
    func validate(_ descriptor: VCLCredentialManifestDescriptor) -> VCLError? {
        validate(
            PublicRequestDescriptor(
                deepLink: descriptor.deepLink,
                endpoint: descriptor.endpoint,
                did: descriptor.did,
                description: descriptor.toPropsString()
            )
        )
    }
    
    private func validate(_ descriptor: PublicRequestDescriptor) -> VCLError? {
        if config.requireDeepLink || descriptor.deepLink != nil {
            guard let deepLink = descriptor.deepLink else {
                return ErrorTaxonomy.invalidLink(
                    message: "Payload is not a parseable URL",
                    sourceErrorCode: VelocityDeepLinkValidator.sourceUnparseablePayload,
                    requestKind: config.requestKind
                )
            }
            if let error = deepLinkValidator.validateDeepLink(
                deepLink,
                expectedPath: config.expectedPath,
                requestKind: config.requestKind
            ) {
                return error
            }
        }
        if let error = deepLinkValidator.validateRequestEndpoint(
            requestUri: descriptor.endpoint,
            requestKind: config.requestKind
        ) {
            return error
        }
        if descriptor.did?.isEmpty != false {
            return ErrorTaxonomy.invalidLink(
                message: "did was not found in \(descriptor.description)",
                requestKind: config.requestKind
            )
        }
        return nil
    }
    
    struct Config {
        let requestKind: String
        let expectedPath: String
        let requireDeepLink: Bool
    }
    
    private struct PublicRequestDescriptor {
        let deepLink: VCLDeepLink?
        let endpoint: String?
        let did: String?
        let description: String
    }
}
