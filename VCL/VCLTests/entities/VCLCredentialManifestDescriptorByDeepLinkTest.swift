//
//  VCLCredentialManifestDescriptorByDeepLinkTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

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
        
        assert(subject.endpoint == VCLCredentialManifestDescriptorMocks.DeepLinkRequestUri.decode()!)
    }
    
    override func tearDown() {
    }
}

