//
//  VCLPresentationRequestDescriptorTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class VCLPresentationRequestDescriptorTest: XCTestCase {
    
    private var subject: VCLPresentationRequestDescriptor!
    
    override func setUp() {
    }
    
    func testPresentationRequestDescriptorWithPushDelegateSuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLink,
            pushDelegate: PresentationRequestDescriptorMocks.PushDelegate,
            didJwk: DidJwkMocks.DidJwk
        )

        let queryParams =
        "\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(PresentationRequestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
        "&\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(PresentationRequestDescriptorMocks.PushDelegate.pushToken.encode()!)"
        let mockEndpoint = (PresentationRequestDescriptorMocks.RequestUri.decode()! + "&" + queryParams)

        assert(subject.endpoint?.decode()?.isUrlEquivalentTo(url: mockEndpoint.decode() ?? "") == true)
        assert(subject.pushDelegate!.pushUrl == PresentationRequestDescriptorMocks.PushDelegate.pushUrl)
        assert(subject.pushDelegate!.pushToken == PresentationRequestDescriptorMocks.PushDelegate.pushToken)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }

    func testPresentationRequestDescriptorWithoutPushDelegateOnlySuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLink,
            didJwk: DidJwkMocks.DidJwk
        )

        assert(subject.endpoint?.decode()?.isUrlEquivalentTo(url: PresentationRequestDescriptorMocks.RequestUri.decode() ?? "") == true)
        assert(subject.pushDelegate == nil)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }

    func testPresentationRequestDescriptorWithQParamsWithPushDelegateSuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLinkWithQParams,
            pushDelegate: PresentationRequestDescriptorMocks.PushDelegate,
            didJwk: DidJwkMocks.DidJwk
        )

        let queryParams =
        "\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(PresentationRequestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
        "&\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(PresentationRequestDescriptorMocks.PushDelegate.pushToken.encode()!)"
        let mockEndpoint = (
            PresentationRequestDescriptorMocks.RequestUri.decode()! + "&" + PresentationRequestDescriptorMocks.QParams + "&" + queryParams
                )

        assert(subject.endpoint?.decode()?.isUrlEquivalentTo(url: mockEndpoint.decode()!) == true)
        assert(subject.pushDelegate!.pushUrl == PresentationRequestDescriptorMocks.PushDelegate.pushUrl)
        assert(subject.pushDelegate!.pushToken == PresentationRequestDescriptorMocks.PushDelegate.pushToken)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }

    func testPresentationRequestDescriptorWithQParamsWithoutPushDelegateOnlySuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLinkWithQParams,
            didJwk: DidJwkMocks.DidJwk
        )

        let mockEndpoint =
        (PresentationRequestDescriptorMocks.RequestUri.decode()! + "&" + PresentationRequestDescriptorMocks.QParams)

        assert(subject.endpoint?.decode()?.isUrlEquivalentTo(url: mockEndpoint.decode()!) == true)
        assert(subject.pushDelegate == nil)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }
    
    func testPresentationRequestDescriptorWithInspectorIdSuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: DeepLinkMocks.PresentationRequestDeepLinkMainNetWithId,
            didJwk: DidJwkMocks.DidJwk
        )

        let mockEndpoint = DeepLinkMocks.PresentationRequestRequestDecodedUriWithIdStr!

        assert(subject.endpoint?.decode()?.isUrlEquivalentTo(url: mockEndpoint) == true)
        assert(subject.pushDelegate == nil)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }
    
    override func tearDown() {
    }
}
