//
//  CredentialManifestUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

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
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.CredentialManifest)
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl()
//                Can't be tested, because of storing exception
//                JwtServiceMicrosoftImpl()
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
            assert((credentialManifest?.jwt.encodedJwt)! == CredentialManifestMocks.CredentialManifestJwt)
            assert((credentialManifest?.jwt.header)! == CredentialManifestMocks.Header)
            assert((credentialManifest?.jwt.payload)! == CredentialManifestMocks.Payload)
            assert((credentialManifest?.jwt.signature)! == CredentialManifestMocks.Signature)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    override func tearDown() {
    }
}
