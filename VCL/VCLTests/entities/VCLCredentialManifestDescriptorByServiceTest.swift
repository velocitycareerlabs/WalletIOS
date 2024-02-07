//
//  VCLCredentialManifestDescriptorByServiceTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 18/08/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLCredentialManifestDescriptorByServiceTest: XCTestCase {
    
    private var subject: VCLCredentialManifestDescriptorByService!
    
    override func setUp() {
    }

    func testCredentialManifestDescriptorByServiceWithFullInput1Success() {
        let service =
        VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            issuingType: VCLIssuingType.Career,
            credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList,
            pushDelegate: CredentialManifestDescriptorMocks.PushDelegate,
            didJwk: DidJwkMocks.DidJwk
        )
        
        let credentialTypesQuery =
        "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint =
        (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)
        
        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }

    func testCredentialManifestDescriptorByServiceWithFullInput2Success() {
        let service =
        VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
        subject = VCLCredentialManifestDescriptorByService(
            service: service,
            issuingType: VCLIssuingType.Identity,
            credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList,
            pushDelegate: CredentialManifestDescriptorMocks.PushDelegate,
            didJwk: DidJwkMocks.DidJwk
        )
        
        let credentialTypesQuery =
        "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
        let mockEndpoint =
        (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)
        
        assert(subject.endpoint == mockEndpoint)
        assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
    }

        func testCredentialManifestDescriptorByServiceWithPartialInput2Success() {
            let service =
            VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
            subject = VCLCredentialManifestDescriptorByService(
                service: service,
                issuingType: VCLIssuingType.Career,
                pushDelegate: CredentialManifestDescriptorMocks.PushDelegate,
                didJwk: DidJwkMocks.DidJwk
            )

            let credentialTypesQuery =
                "\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
                        "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
            let mockEndpoint =
                (CredentialManifestDescriptorMocks.IssuingServiceEndPoint + "?" + credentialTypesQuery)

            assert(subject.endpoint == mockEndpoint)
            assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
        }

        func testCredentialManifestDescriptorByServiceWithPartialInput3Success() {
            let service =
            VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
            subject = VCLCredentialManifestDescriptorByService(
                service: service,
                issuingType: VCLIssuingType.Career,
                credentialTypes: CredentialManifestDescriptorMocks.CredentialTypesList,
                didJwk: DidJwkMocks.DidJwk
            )

            let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[0])" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyCredentialTypes)=\(CredentialManifestDescriptorMocks.CredentialTypesList[1])"
            let mockEndpoint =
                (CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

            assert(subject.endpoint == mockEndpoint)
            assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
        }

        func testCredentialManifestDescriptorByServiceWithPartialInput4Success() {
            let service =
            VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
            subject = VCLCredentialManifestDescriptorByService(
                service: service,
                issuingType: VCLIssuingType.Career,
                pushDelegate: CredentialManifestDescriptorMocks.PushDelegate,
                didJwk: DidJwkMocks.DidJwk
            )

            let credentialTypesQuery =
            "\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(CredentialManifestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
            "&\(VCLCredentialManifestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(CredentialManifestDescriptorMocks.PushDelegate.pushToken)"
            let mockEndpoint =
                (CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint + "&" + credentialTypesQuery)

            assert(subject.endpoint == mockEndpoint)
            assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
        }

        func testCredentialManifestDescriptorByServiceWithPartialInput5Success() {
            let service =
            VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceWithParamJsonStr.toDictionary()!)
            subject = VCLCredentialManifestDescriptorByService(
                service: service,
                issuingType: VCLIssuingType.Career,
                didJwk: DidJwkMocks.DidJwk
            )
            let mockEndpoint = CredentialManifestDescriptorMocks.IssuingServiceWithParamEndPoint

            assert(subject.endpoint == mockEndpoint)
            assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
        }

        func testCredentialManifestDescriptorByServiceWithPartialInput6Success() {
            let service =
            VCLServiceCredentialAgentIssuer(payload: CredentialManifestDescriptorMocks.IssuingServiceJsonStr.toDictionary()!)
            subject = VCLCredentialManifestDescriptorByService(
                service: service,
                didJwk: DidJwkMocks.DidJwk
            )
            let mockEndpoint = (CredentialManifestDescriptorMocks.IssuingServiceEndPoint)

            assert(subject.endpoint == mockEndpoint)
            assert(subject.did == CredentialManifestDescriptorMocks.IssuerDid)
        }

    
    override func tearDown() {
    }
}
