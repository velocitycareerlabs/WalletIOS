//
//  ExchangeProgressUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 30/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ExchangeProgressUseCaseTest: XCTestCase {
    
    var subject: ExchangeProgressUseCase!
    
    override func setUp() {
    }
    
    func testGetExchangeProgress() {
        // Arrange
        subject = ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceSuccess(validResponse: ExchangeProgressMocks.ExchangeProgressJson)
            ),
            EmptyExecutor()
        )
        var result: VCLResult<VCLExchange>? = nil
        let submissionResult = VCLSubmissionResult(token: VCLToken(value: ""), exchange: VCLExchange(), jti: "", submissionId: "")
        let exchangeDescriptor = VCLExchangeDescriptor(
            presentationSubmission: VCLPresentationSubmission(
                presentationRequest: PresentationRequestMocks.PresentationRequest,
                verifiableCredentials: []), submissionResult: submissionResult
        )
        
        // Action
        subject.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) {
            result = $0
        }
        
        // Assert
        do {
            let exchange = try result?.get()
            assert(exchange == expectedExchange(exchangeJsonDict: ExchangeProgressMocks.ExchangeProgressJson.toDictionary()!))
        } catch {
            XCTFail()
        }
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
