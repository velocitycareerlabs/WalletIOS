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
    
    private var subject: VCLDeepLink!
    
    func testOpenidInitiateIssuance() {
        subject = VCLDeepLink(value: DeepLinkMocks.OpenidInitiateIssuanceStrDev)

        assert(subject.value == DeepLinkMocks.OpenidInitiateIssuanceStrDev)
        assert(subject.value.decode() == DeepLinkMocks.OpenidInitiateIssuanceStrDev.decode())
        assert(subject.requestUri == nil)
        assert(subject.did == DeepLinkMocks.OIDIssuerDid)
    }

    func testPresentationRequestDeepLinkDevNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkDevNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkDevNetStr.decode())
//            TODO: FIX
//        assert(subject.requestUri?.isUrlEquivalentTo(url: DeepLinkMocks.PresentationRequestRequestDecodedUriStr ?? "") == true)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
        assert(subject.did == DeepLinkMocks.InspectorDid)
    }

    func testPresentationRequestDeepLinkTestNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkTestNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkTestNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkTestNetStr.decode())
//            TODO: FIX
//        assert(subject.requestUri?.isUrlEquivalentTo(url: DeepLinkMocks.PresentationRequestRequestDecodedUriStr ?? "") == true)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
        assert(subject.did == DeepLinkMocks.InspectorDid)
    }

    func testPresentationRequestDeepLinkMainNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkMainNetStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkMainNetStr)
        assert(subject.value.decode() == DeepLinkMocks.PresentationRequestDeepLinkMainNetStr.decode())
//            TODO: FIX
//        assert(subject.requestUri?.isUrlEquivalentTo(url: DeepLinkMocks.PresentationRequestRequestDecodedUriStr ?? "") == true)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
        assert(subject.did == DeepLinkMocks.InspectorDid)
    }

    func testCredentialManifestDeepLinkDevNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkDevNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkDevNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkDevNetStr.decode())
//            TODO: FIX
//        assert(subject.requestUri?.isUrlEquivalentTo(url: DeepLinkMocks.CredentialManifestRequestDecodedUriStr) == true)
        assert(subject.vendorOriginContext == nil)
        assert(subject.did == DeepLinkMocks.IssuerDid)
    }

    func testCredentialManifestDeepLinkTestNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkTestNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkTestNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkTestNetStr.decode())
//            TODO: FIX
//        assert(subject.requestUri?.isUrlEquivalentTo(url: DeepLinkMocks.CredentialManifestRequestDecodedUriStr) == true)
        assert(subject.vendorOriginContext == nil)
        assert(subject.did == DeepLinkMocks.IssuerDid)
    }

    func testCredentialManifestDeepLinkKeepsRepeatedCredentialTypes() {
        subject = VCLDeepLink(value: DeepLinkMocks.HubCredentialManifestDeepLinkStr)

        XCTAssertEqual(serverQueryValues(subject.requestUri, key: "credential_types"), DeepLinkMocks.HubCredentialTypes)
        XCTAssertEqual(
            subject.requestUri?.decode()?.isUrlEquivalentTo(url: DeepLinkMocks.HubCredentialManifestRequestDecodedUriStr),
            true
        )
        XCTAssertEqual(subject.vendorOriginContext, DeepLinkMocks.HubVendorOriginContext)
        XCTAssertEqual(subject.did, DeepLinkMocks.HubIssuerDid)
    }

    func testCredentialManifestDeepLinkTakesCredentialTypesFromRequestUri() {
        subject = VCLDeepLink(value: DeepLinkMocks.StrayCredentialTypeDeepLinkStr)

        XCTAssertEqual(serverQueryValues(subject.requestUri, key: "credential_types"), DeepLinkMocks.HubCredentialTypes)
    }

    func testCredentialManifestDeepLinkMainNetValidAggregation() {
        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkMainNetStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkMainNetStr)
        assert(subject.value.decode() == DeepLinkMocks.CredentialManifestDeepLinkMainNetStr.decode())
//            TODO: FIX
//        assert(subject.requestUri?.isUrlEquivalentTo(url: DeepLinkMocks.CredentialManifestRequestDecodedUriStr) == true)
        assert(subject.vendorOriginContext == nil)
        assert(subject.did == DeepLinkMocks.IssuerDid)
    }

    // Every value of a key in the URL's query, read as a server reads it: split at `&`, then at the first `=`, with
    // each value form-decoded. Text encoded inside another value stays in that value.
    private func serverQueryValues(_ url: String?, key: String) -> [String] {
        guard let url = url, let start = url.firstIndex(of: "?") else {
            return []
        }
        var values: [String] = []
        for item in url[url.index(after: start)...].components(separatedBy: "&") {
            let pair: [Substring] = item.split(separator: "=", maxSplits: 1, omittingEmptySubsequences: false)
            if pair.count == 2 && pair[0] == Substring(key) {
                let value = String(pair[1]).replacingOccurrences(of: "+", with: " ")
                values.append(value.removingPercentEncoding ?? value)
            }
        }
        return values
    }
}
