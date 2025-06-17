//
//  VCLCredentialManifestDescriptorByDeepLinkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorByDeepLinkTest: XCTestCase {
    
    var subject: VCLCredentialManifestDescriptorByDeepLink!
    
    override func setUp() {
    }

    func testCredentialManifestDescriptorFullValidByDeepLinkSuccess() {
        subject = VCLCredentialManifestDescriptorByDeepLink(
            deepLink: CredentialManifestDescriptorMocks.DeepLink,
            issuingType: VCLIssuingType.Career,
            pushDelegate: VCLPushDelegate(pushUrl: "some_url", pushToken: "some_token"),
            didJwk: DidJwkMocks.DidJwk
        )
        
        assert(subject.endpoint?.decode()?.isUrlEquivalentTo(
            url: CredentialManifestDescriptorMocks.DeepLinkRequestUri.decode()! + "&push_delegate.push_url=some_url&push_delegate.push_token=some_token"
        ) == true)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
        assert(subject.pushDelegate?.pushUrl == "some_url")
        assert(subject.pushDelegate?.pushToken == "some_token")
    }
    
    func testCredentialManifestDescriptorFullValidByDeepLinkWithIdSuccess() {
        subject = VCLCredentialManifestDescriptorByDeepLink(
            deepLink: DeepLinkMocks.CredentialManifestDeepLinkMainNetWithId,
            issuingType: VCLIssuingType.Career,
            pushDelegate: VCLPushDelegate(pushUrl: "some_url", pushToken: "some_token"),
            didJwk: DidJwkMocks.DidJwk
        )

        assert(
            subject.endpoint?.decode()?.isUrlEquivalentTo(
                url: DeepLinkMocks.CredentialManifestRequestDecodedUriWithIdStr + "&push_delegate.push_url=some_url&push_delegate.push_token=some_token"
            ) == true
        )
        assert(subject.did == DeepLinkMocks.IssuerDid)
        assert(subject.pushDelegate?.pushUrl == "some_url")
        assert(subject.pushDelegate?.pushToken == "some_token")
    }
    
    override func tearDown() {
    }
}

