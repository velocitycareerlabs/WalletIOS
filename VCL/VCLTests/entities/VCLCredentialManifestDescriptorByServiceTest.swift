//
//  VCLCredentialManifestDescriptorByServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/08/2021.
//

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorByServiceTest: XCTestCase {
    
    var subject: VCLCredentialManifestDescriptorByService!
    
    override func setUp() {
    }

    func testCredentialManifestDescriptorWithFullInputByServiceSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            credentialTypes: VCLCredentialManifestDescriptorMocks.CredentialTypesList,
            pushDelegate: VCLCredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[1])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorWithCredentialTypesByServiceSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            credentialTypes: VCLCredentialManifestDescriptorMocks.CredentialTypesList
        )
        
        let credentialTypesQuery =
        "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[1])"
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorWithPushDelegateByServiceSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            pushDelegate: VCLCredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorServiceOnlySuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service
        )
        
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceEndPoint)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorWithFullInputByServiceWithParamSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            credentialTypes: VCLCredentialManifestDescriptorMocks.CredentialTypesList,
            pushDelegate: VCLCredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[1])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorWithCredentialTypesByServiceWithParamSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            credentialTypes: VCLCredentialManifestDescriptorMocks.CredentialTypesList
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(VCLCredentialManifestDescriptorMocks.CredentialTypesList[1])"
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorWithPushDelegateByServiceWithParamSuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            pushDelegate: VCLCredentialManifestDescriptorMocks.PushDelegate
        )
        
        let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode() ?? "")" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(VCLCredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

        assert(subject.endpoint == mockEndpoint)
    }
    
    func testCredentialManifestDescriptorServiceWithParamOnlySuccess() {
        let service = VCLService(payload: VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service
        )
        
        let mockEndpoint = (VCLCredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint)

        assert(subject.endpoint == mockEndpoint)
    }
    
    override func tearDown() {
    }
}
