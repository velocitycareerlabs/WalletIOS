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
    
    private var subject: CredentialManifestUseCase!

    override func setUp() {
    }

    func testGetCredentialManifestSuccess() {
        subject = CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.CredentialManifest1)
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)),
                VCLJwtVerifyServiceLocalImpl()
            ),
            CredentialManifestByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )

        subject.getCredentialManifest(
            credentialManifestDescriptor: VCLCredentialManifestDescriptorByDeepLink(
                deepLink: DeepLinkMocks.CredentialManifestDeepLinkDevNet,
                issuingType: VCLIssuingType.Career
            ),
            verifiedProfile: VCLVerifiedProfile(
                payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!
            ),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let credentialManifest = try $0.get()
                assert(credentialManifest.jwt.encodedJwt == CredentialManifestMocks.JwtCredentialManifest1)
                assert(credentialManifest.jwt.header! == CredentialManifestMocks.Header)
                assert(
                    credentialManifest.jwt.payload!.toJsonString()?
                        .replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal)
                        .sorted() ==
                    CredentialManifestMocks.Payload.toJsonString()?
                        .replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal)
                        .sorted()
                ) // removed $ to compare
                assert(credentialManifest.jwt.signature == CredentialManifestMocks.Signature)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testGetCredentialManifestFailure() {
        subject = CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceSuccess(validResponse: "wrong payload")
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: CredentialManifestMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)),
                VCLJwtVerifyServiceLocalImpl()
            ),
            CredentialManifestByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )

        subject.getCredentialManifest(
            credentialManifestDescriptor: VCLCredentialManifestDescriptorByDeepLink(
                deepLink: DeepLinkMocks.CredentialManifestDeepLinkDevNet,
                issuingType: VCLIssuingType.Career
            ),
            verifiedProfile: VCLVerifiedProfile(
                payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!
            ),
            remoteCryptoServicesToken: nil
        ) {
            do {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.SdkError.rawValue) error code is expected")
            } catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.SdkError.rawValue)
            }
        }
    }

    override func tearDown() {
    }
}
