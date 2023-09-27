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
    
    var subject: VCLPresentationRequestDescriptor!
    
    override func setUp() {
    }
    
    func testPresentationRequestDescriptorWithPushDelegateSuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLink,
            pushDelegate: PresentationRequestDescriptorMocks.PushDelegate
        )

        let queryParams =
        "\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(PresentationRequestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
        "&\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(PresentationRequestDescriptorMocks.PushDelegate.pushToken.encode()!)"
        let mockEndpoint = (PresentationRequestDescriptorMocks.RequestUri.decode()! + "?" + queryParams)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.pushDelegate!.pushUrl == PresentationRequestDescriptorMocks.PushDelegate.pushUrl)
        assert(subject.pushDelegate!.pushToken == PresentationRequestDescriptorMocks.PushDelegate.pushToken)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }
    
    func testPresentationRequestDescriptorWithoutPushDelegateOnlySuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLink
        )

        assert(subject.endpoint == PresentationRequestDescriptorMocks.RequestUri.decode()!)
        assert(subject.pushDelegate == nil)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }
    
    func testPresentationRequestDescriptorWithQParamsWithPushDelegateSuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLinkWithQParams,
            pushDelegate: PresentationRequestDescriptorMocks.PushDelegate
        )

        let queryParams =
        "\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushUrl)=\(PresentationRequestDescriptorMocks.PushDelegate.pushUrl.encode()!)" +
        "&\(VCLPresentationRequestDescriptor.CodingKeys.KeyPushDelegatePushToken)=\(PresentationRequestDescriptorMocks.PushDelegate.pushToken.encode()!)"
        let mockEndpoint = (
                PresentationRequestDescriptorMocks.RequestUri.decode()! + "?" + PresentationRequestDescriptorMocks.QParms + "&" + queryParams
                )

        assert(subject.endpoint == mockEndpoint)
        assert(subject.pushDelegate!.pushUrl == PresentationRequestDescriptorMocks.PushDelegate.pushUrl)
        assert(subject.pushDelegate!.pushToken == PresentationRequestDescriptorMocks.PushDelegate.pushToken)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }
    
    func testPresentationRequestDescriptorWithQParamsWithoutPushDelegateOnlySuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLinkWithQParams
        )

        let mockEndpoint =
            (PresentationRequestDescriptorMocks.RequestUri.decode()! + "?" + PresentationRequestDescriptorMocks.QParms)

        assert(subject.endpoint == mockEndpoint)
        assert(subject.pushDelegate == nil)
        assert(subject.did == PresentationRequestDescriptorMocks.InspectorDid)
    }
    
    override func tearDown() {
    }
}
