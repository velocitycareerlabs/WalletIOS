//
//  VCLCredentialManifestDescriptorByDeepLinkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorByDeepLinkTest: XCTestCase {
    
    var subject: VCLCredentialManifestDescriptorByDeepLink!
    
    override func setUp() {
    }

    func testCredentialManifestDescriptorFullValidByDeepLinkSuccess() {
        subject = VCLCredentialManifestDescriptorByDeepLink(
            deepLink: VCLCredentialManifestDescriptorMocks.DeepLink
        )
        
        assert(subject.endpoint == VCLCredentialManifestDescriptorMocks.DeepLinkRequestUri)
    }
    
    override func tearDown() {
    }
}

