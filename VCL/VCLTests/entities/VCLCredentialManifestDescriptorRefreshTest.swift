//
//  VCLCredentialManifestDescriptorRefreshTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 12/04/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorRefreshTest: XCTestCase {
    
    var subject: VCLCredentialManifestDescriptorRefresh!
    
    override func setUp() {
    }
    
    func testCredentialManifestDescriptorWith2CredentialIdsSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: [VCLCredentialManifestDescriptorMocks.CredentialId1, VCLCredentialManifestDescriptorMocks.CredentialId2])

        let credentialTypesQuery = "\(VCLCredentialManifestDescriptor.CodingKeys.KeyRefresh)=\(true)" +
                        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialId)=\(VCLCredentialManifestDescriptorMocks.CredentialId1.encode()!)" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialId)=\(VCLCredentialManifestDescriptorMocks.CredentialId2.encode()!)"
            let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

            assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorWith1CredentialIdsSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: [VCLCredentialManifestDescriptorMocks.CredentialId1])

        let credentialTypesQuery = "\(VCLCredentialManifestDescriptor.CodingKeys.KeyRefresh)=\(true)" +
                        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialId)=\(VCLCredentialManifestDescriptorMocks.CredentialId1.encode()!)"
            let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

            assert(subject.endpoint == mockEndpoint)
    }

    func testCredentialManifestDescriptorWith0CredentialIdsSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: [])

        let credentialTypesQuery = "\(VCLCredentialManifestDescriptor.CodingKeys.KeyRefresh)=\(true)"
            let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

            assert(subject.endpoint == mockEndpoint)
    }
    
    override func tearDown() {
    }
}
