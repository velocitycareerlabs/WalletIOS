//
//  VCLDeepLinkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

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
        assert(subject.did == DeepLinkMocks.OIDIssuerDid)
    }

    func testPresentationRequestDeepLinkDevNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkDevNetStr.decode())
        assert(subject.requestUri!.decode() == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.issuer == nil)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
        assert(subject.did == DeepLinkMocks.InspectorDid)
    }

    func testPresentationRequestDeepLinkTestNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkTestNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkTestNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkTestNetStr.decode())
        assert(subject.requestUri!.decode() == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.issuer == nil)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
        assert(subject.did == DeepLinkMocks.InspectorDid)
    }

    func testPresentationRequestDeepLinkMainNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkMainNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkMainNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkMainNetStr.decode())
        assert(subject.requestUri!.decode() == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.issuer == nil)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
        assert(subject.did == DeepLinkMocks.InspectorDid)
    }

    func testCredentialManifestDeepLinkDevNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkDevNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkDevNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkDevNetStr.decode())
        assert(subject.requestUri!.decode() == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.issuer == nil)
        assert(subject.vendorOriginContext == nil)
        assert(subject.did == DeepLinkMocks.IssuerDid)
    }

    func testCredentialManifestDeepLinkTestNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkTestNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkTestNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkTestNetStr.decode())
        assert(subject.requestUri!.decode() == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.issuer == nil)
        assert(subject.vendorOriginContext == nil)
        assert(subject.did == DeepLinkMocks.IssuerDid)
    }

    func testCredentialManifestDeepLinkMainNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkMainNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkMainNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkMainNetStr.decode())
        assert(subject.requestUri!.decode() == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.issuer == nil)
        assert(subject.vendorOriginContext == nil)
        assert(subject.did == DeepLinkMocks.IssuerDid)
    }
    
    override func tearDown() {
    }
}
