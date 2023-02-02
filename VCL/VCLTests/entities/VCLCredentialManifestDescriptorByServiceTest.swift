//
//  VCLCredentialManifestDescriptorByServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/08/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorByServiceTest: XCTestCase {
    
    var subject: VCLCredentialManifestDescriptorByService!
    
    override func setUp() {
    }

    func testCredentialManifestDescriptorWithFullInputByServiceSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer,
            credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList,
            pushDelegate: CredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWithCredentialTypesByServiceSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer,
            credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList
        )
        
        let credentialTypesQuery =
        "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWithPushDelegateByServiceSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer,
            pushDelegate: CredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorServiceOnlySuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer
        )
        
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWithFullInputByServiceWithParamSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer,
            credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList,
            pushDelegate: CredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWithCredentialTypesByServiceWithParamSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer,
            credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorWithPushDelegateByServiceWithParamSuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer,
            pushDelegate: CredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    func testCredentialManifestDescriptorServiceWithParamOnlySuccess() {
        let service = VCLService(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            serviceType: VCLServiceType.Issuer
        )
        
        let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }
    
    override func tearDown() {
    }
}
