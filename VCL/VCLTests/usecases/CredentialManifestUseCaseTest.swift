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
    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)

    override func setUp() {
        keyService.generateDidJwk { [weak self] didJwkResult in
            do {
                self?.didJwk = try didJwkResult.get()
            } catch {
                assert(false, "Failed to generate did:jwk \(error)" )
            }
        }
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
                issuingType: VCLIssuingType.Career,
                didJwk: didJwk,
                remoteCryptoServicesToken: VCLToken(value: "some token")
            ),
            verifiedProfile: VCLVerifiedProfile(
                payload: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1.toDictionary()!
            )
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
                assert(credentialManifest.didJwk?.did == self.didJwk.did)
                assert(credentialManifest.remoteCryptoServicesToken?.value == "some token")
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
            )
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
