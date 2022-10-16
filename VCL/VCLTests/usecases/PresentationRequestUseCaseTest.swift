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

final class PresentationRequestUseCaseTest: XCTestCase {
    
    var subject: PresentationRequestUseCase!
    
    override func setUp() {
    }
    
    func testCountryCodesSuccess() {
        // Arrange
        subject = PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationRequestMocks.EncodedPresentationRequestResponse)
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: JwtServiceMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                JwtServiceSuccess(VclJwt: PresentationRequestMocks.PresentationRequestJwt)
//                Can't be tested, because of storing exception
//                JwtServiceMicrosoftImpl()
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLPresentationRequest>? = nil
        
        // Action
        subject.getPresentationRequest(deepLink: VCLDeepLink(value: "")) {
            result = $0
        }
        
        // Assert
        do {
            let presentationRequest = try result?.get()
            
//            JWK Dictionary
            assert(presentationRequest?.publicKey == VCLPublicKey(jwkDict: PresentationRequestMocks.JWK.toDictionary()!))
            assert((presentationRequest?.jwt.encodedJwt)! == PresentationRequestMocks.PresentationRequestJwt.encodedJwt)
            assert((presentationRequest?.jwt.header)! == PresentationRequestMocks.PresentationRequestJwt.header!)
            assert((presentationRequest?.jwt.payload)! == PresentationRequestMocks.PresentationRequestJwt.payload!)
            
//            JWK String
            assert(presentationRequest?.publicKey == VCLPublicKey(jwkStr: PresentationRequestMocks.JWK))
            assert((presentationRequest?.jwt.encodedJwt)! == PresentationRequestMocks.PresentationRequestJwt.encodedJwt)
            assert((presentationRequest?.jwt.header)! == PresentationRequestMocks.PresentationRequestJwt.header!)
            assert((presentationRequest?.jwt.payload)! == PresentationRequestMocks.PresentationRequestJwt.payload!)
        } catch {
            XCTFail()
        }
    }
    
    override func tearDown() {
    }
}
