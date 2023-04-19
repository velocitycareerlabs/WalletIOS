//
//  PresentationRequestUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 04/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

/// TODO: Test after updating Micrisoft jwt library
final class PresentationRequestUseCaseTest: XCTestCase {
    
    var subject: PresentationRequestUseCase!
    
    override func setUp() {
    }
    
    func testCountryCodesSuccess() {
        // Arrange
        let pushUrl = "push_url"
        let pushToken = "push_token"
        subject = PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationRequestMocks.EncodedPresentationRequestResponse)
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: JwtServiceMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                JwtServiceSuccess(
                    VclJwt: PresentationRequestMocks.PresentationRequestJwt,
                    VclDidJwk: JwtServiceMocks.didJwk
                )
//                Can't be tested, because of storing exception
//                JwtServiceMicrosoftImpl()
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLPresentationRequest>? = nil

        // Action
        subject.getPresentationRequest(presentationRequestDescriptor: VCLPresentationRequestDescriptor(
            deepLink: DeepLinkMocks.PresentationRequestDeepLinkDevNet,
            pushDelegate: VCLPushDelegate(
                pushUrl: pushUrl,
                pushToken: pushToken
            )
        )) {
            result = $0
        }

        // Assert
        do {
            let presentationRequest = try result!.get()

            assert(presentationRequest.jwkPublic.valueDict == VCLJwkPublic(valueDict: PresentationRequestMocks.JWK.toDictionary()!).valueDict)
            assert(presentationRequest.jwt.encodedJwt == PresentationRequestMocks.PresentationRequestJwt.encodedJwt)
            assert(presentationRequest.jwt.header! == PresentationRequestMocks.PresentationRequestJwt.header!)
            assert(presentationRequest.jwt.payload! == PresentationRequestMocks.PresentationRequestJwt.payload!)
            assert(presentationRequest.pushDelegate!.pushUrl == pushUrl)
            assert(presentationRequest.pushDelegate!.pushToken == pushToken)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    override func tearDown() {
    }
}
