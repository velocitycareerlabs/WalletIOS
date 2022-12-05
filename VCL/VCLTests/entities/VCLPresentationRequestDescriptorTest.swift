//
//  VCLPresentationRequestDescriptorTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/12/2022.
//

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
        let mockEndpoint = ((PresentationRequestDescriptorMocks.RequestUri.decode()!) + "?" + queryParams)
        
        assert(subject.endpoint == mockEndpoint)
    }
    
    func testPresentationRequestDescriptorWithoutPushDelegateOnlySuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLink
        )
        
        assert(subject.endpoint == PresentationRequestDescriptorMocks.RequestUri.decode())
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
    }
    
    func testPresentationRequestDescriptorWithQParamsWithoutPushDelegateOnlySuccess() {
        subject = VCLPresentationRequestDescriptor(
            deepLink: PresentationRequestDescriptorMocks.DeepLinkWithQParams
        )
        
        let mockEndpoint = (PresentationRequestDescriptorMocks.RequestUri.decode()! + "?" + PresentationRequestDescriptorMocks.QParms)
        
        assert(subject.endpoint == mockEndpoint)
    }
    
    override func tearDown() {
    }
}
