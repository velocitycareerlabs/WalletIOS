//
//  CredentialManifestUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class CredentialManifestUseCaseTest: XCTestCase {
    
    var subject: CredentialManifestUseCase!

    override func setUp() {
    }

    func testGetCredentialManifest() {
        // Arrange
        subject = CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.CredentialManifest1)
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl(secretStore: SecretStoreMock.Instance))
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLCredentialManifest>? = nil

        // Action
        subject.getCredentialManifest(
            credentialManifestDescriptor: VCLCredentialManifestDescriptorByDeepLink(
                deepLink: DeepLinkMocks.CredentialManifestDeepLinkDevNet,
                issuingType: VCLIssuingType.Career
            )
        ) {
            result = $0
        }

        // Assert
        do {
            let credentialManifest = try result?.get()
            assert(credentialManifest!.jwt.encodedJwt == CredentialManifestMocks.CredentialManifestJwt1)
            assert(credentialManifest!.jwt.header! == CredentialManifestMocks.Header)
            assert(
                credentialManifest!.jwt.payload!.toJsonString()?
                    .replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal)
                    .sorted() ==
                CredentialManifestMocks.Payload.toJsonString()?
                    .replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal)
                    .sorted()
            ) // removed $ to compare
            assert(credentialManifest!.jwt.signature == CredentialManifestMocks.Signature)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    override func tearDown() {
    }
}
