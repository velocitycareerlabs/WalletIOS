//
//  PresentationRequestUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 04/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class PresentationRequestUseCaseTest: XCTestCase {
    
    private var subject: PresentationRequestUseCase!
    
    func testCountryCodesSuccess() {
        // Arrange
        let pushUrl = "push_url"
        let pushToken = "push_token"
        subject = PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationRequestMocks.EncodedPresentationRequestResponse)
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationRequestMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)),
                VCLJwtVerifyServiceLocalImpl()
            ),
            PresentationRequestByDeepLinkVerifierImpl(),
            ExecutorImpl()
        )
        subject.getPresentationRequest(presentationRequestDescriptor: VCLPresentationRequestDescriptor(
            deepLink: DeepLinkMocks.PresentationRequestDeepLinkDevNet,
            pushDelegate: VCLPushDelegate(
                pushUrl: pushUrl,
                pushToken: pushToken
            )
        ), remoteCryptoServicesToken: nil
        ) {
            do {
                let presentationRequest = try $0.get()

                assert(presentationRequest.publicJwk.valueStr.sorted() == VCLPublicJwk(valueDict: PresentationRequestMocks.JWK.toDictionary()!).valueStr.sorted())
                assert(presentationRequest.publicJwk.valueDict == VCLPublicJwk(valueDict: PresentationRequestMocks.JWK.toDictionary()!).valueDict)
                assert(presentationRequest.jwt.encodedJwt == PresentationRequestMocks.PresentationRequestJwt.encodedJwt)
                assert(presentationRequest.jwt.header! == PresentationRequestMocks.PresentationRequestJwt.header!)
                assert(presentationRequest.jwt.payload! == PresentationRequestMocks.PresentationRequestJwt.payload!)
                assert(presentationRequest.pushDelegate!.pushUrl == pushUrl)
                assert(presentationRequest.pushDelegate!.pushToken == pushToken)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
