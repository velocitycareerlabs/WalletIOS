//
//  VCLDeepLinkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//

import Foundation
import XCTest
@testable import VCL

final class VCLDeepLinkTest: XCTestCase {
    
    var subject: VCLDeepLink!
    
    override func setUp() {
    }

    func testPresentationRequestDeepLinkValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.PresentationRequestDeepLinkStr)

        assert(subject.value == DeepLinkMocks.PresentationRequestDeepLinkStr)
        assert(subject.value.decode()! == DeepLinkMocks.PresentationRequestDeepLinkStr.decode()!)
        assert(subject.requestUri == DeepLinkMocks.PresentationRequestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == DeepLinkMocks.PresentationRequestVendorOriginContext)
    }

    func testCredentialManifestDeepLinkValidAggregation() {

        subject = VCLDeepLink(value: DeepLinkMocks.CredentialManifestDeepLinkStr)

        assert(subject.value == DeepLinkMocks.CredentialManifestDeepLinkStr)
        assert(subject.value.decode()! == DeepLinkMocks.CredentialManifestDeepLinkStr.decode()!)
        assert(subject.requestUri == DeepLinkMocks.CredentialManifestRequestDecodedUriStr)
        assert(subject.vendorOriginContext == nil)
    }
    
    override func tearDown() {
    }
}
