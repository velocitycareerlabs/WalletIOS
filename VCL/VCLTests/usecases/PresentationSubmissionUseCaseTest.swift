//
//  PresentationSubmissionUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class PresentationSubmissionUseCaseTest: XCTestCase {
    
    var subject: PresentationSubmissionUseCase!
    
    override func setUp() {
    }
    
    func testSubmitPresentationSuccess() {
        // Arrange
        subject = PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationSubmissionMocks.PresentationSubmissionResultJson)),
            JwtServiceRepositoryImpl(
                JwtServiceSuccess(VclJwt: PresentationSubmissionMocks.PresentationSubmissionJwt)
//                Can't be tested, because of storing exception
//                JwtServiceMicrosoftImpl()
            ),
            EmptyExecutor()
        )
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: VCLPresentationRequest(
                jwt: VCLJWT(encodedJwt: ""),
                publicKey: VCLPublicKey(jwkStr: "{}"),
                deepLink: VCLDeepLink(value: "")),
            verifiableCredentials: [VCLVerifiableCredential]()
        )
        var result: VCLResult<VCLPresentationSubmissionResult>? = nil
        
        // Action
        subject.submit(submission: presentationSubmission) {
            result = $0
        }
        
        // Assert
        do {
            let presentationSubmissionResult = try result?.get()
            assert(presentationSubmissionResult == expectedPresentationSubmissionResult(jsonDict: PresentationSubmissionMocks.PresentationSubmissionResultJson.toDictionary()!))
        } catch {
            XCTFail()
        }
    }
    
    private func expectedPresentationSubmissionResult(jsonDict: [String: Any]) -> VCLPresentationSubmissionResult {
        let exchangeJsonDict = jsonDict[VCLPresentationSubmissionResult.CodingKeys.KeyExchange]
        return VCLPresentationSubmissionResult(
            token: VCLToken(value: (jsonDict[VCLPresentationSubmissionResult.CodingKeys.KeyToken] as! String)),
            exchange: expectedExchange(exchangeJsonDict: exchangeJsonDict as! [String : Any])
        )
    }
    
    private func expectedExchange(exchangeJsonDict: [String: Any]) -> VCLExchange {
        return VCLExchange(id: (exchangeJsonDict[VCLExchange.CodingKeys.KeyId] as! String),
                           type: (exchangeJsonDict[VCLExchange.CodingKeys.KeyType] as! String),
                           disclosureComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyDisclosureComplete] as! Bool),
                           exchangeComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyExchangeComplete] as! Bool))
    }
    
    override func tearDown() {
    }
}
