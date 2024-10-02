//
//  VCLCredentialManifestDescriptorRefreshTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 12/04/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorRefreshTest: XCTestCase {
    
    private var subject: VCLCredentialManifestDescriptorRefresh!
    
    override func setUp() {
    }
    
    func testCredentialManifestDescriptorWith2CredentialIdsSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: [CredentialManifestDescriptorMocks.CredentialId1, CredentialManifestDescriptorMocks.CredentialId2],
            didJwk: DidJwkMocks.DidJwk
        )
        
        let credentialTypesQuery = "\(CredentialManifestDescriptorCodingKeys.KeyRefresh)=\(true)" +
        "&\(CredentialManifestDescriptorCodingKeys.KeyCredentialId)=\(CredentialManifestDescriptorMocks.CredentialId1.encode()!)" +
        "&\(CredentialManifestDescriptorCodingKeys.KeyCredentialId)=\(CredentialManifestDescriptorMocks.CredentialId2.encode()!)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)
        
        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWith1CredentialIdsSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: [CredentialManifestDescriptorMocks.CredentialId1],
            didJwk: DidJwkMocks.DidJwk
        )
        let credentialTypesQuery = "\(CredentialManifestDescriptorCodingKeys.KeyRefresh)=\(true)" +
        "&\(CredentialManifestDescriptorCodingKeys.KeyCredentialId)=\(CredentialManifestDescriptorMocks.CredentialId1.encode()!)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)
        
        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWith0CredentialIdsSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: [],
            didJwk: DidJwkMocks.DidJwk
        )
        let credentialTypesQuery = "\(CredentialManifestDescriptorCodingKeys.KeyRefresh)=\(true)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)
        
        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    override func tearDown() {
    }
}
