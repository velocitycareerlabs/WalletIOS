//
//  VCLDeepLinkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLDeepLinkTest: XCTestCase {
    
    var subject: VCLDeepLink!
    
    override func setUp() {
    }
    
    func testOpenidInitiateIssuance() {
        subject = VCLDeepLink(value: DeepLinkMocks.OpenidInitiateIssuanceStrDev)

        assert(subject.value == DeepLinkMocks.OpenidInitiateIssuanceStrDev)
        assert(subject.value.decode() == DeepLinkMocks.OpenidInitiateIssuanceStrDev.decode())
        assert(subject.requestUri == nil)
        assert(subject.issuer == DeepLinkMocks.IssuerDecoded)
    }

    func testPresentationRequestDeepLinkDevNetValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkDevNetStr.decode())
        assert(subject.issuer == nil)
        assert(subject.requestUri == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
    }

    func testPresentationRequestDeepLinkTestNetValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkTestNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkTestNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkTestNetStr.decode())
        assert(subject.issuer == nil)
        assert(subject.requestUri == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
    }

    func testPresentationRequestDeepLinkMainNetValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkMainNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkMainNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkMainNetStr.decode())
        assert(subject.issuer == nil)
        assert(subject.requestUri == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
    }

    func testCredentialManifestDeepLinkDevNetValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkDevNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkDevNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkDevNetStr.decode())
        assert(subject.issuer == nil)
        assert(subject.requestUri == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == nil)
    }

    func testCredentialManifestDeepLinkTestNetValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkTestNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkTestNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkTestNetStr.decode())
        assert(subject.issuer == nil)
        assert(subject.requestUri == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == nil)
    }

    func testCredentialManifestDeepLinkMainNetValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkMainNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkMainNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkMainNetStr.decode())
        assert(subject.issuer == nil)
        assert(subject.requestUri == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == nil)
    }
    
    override func tearDown() {
    }
}
