//
//  ExchangeProgressUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 30/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ExchangeProgressUseCaseTest: XCTestCase {
    
    var subject: ExchangeProgressUseCase!
    
    override func setUp() {
    }
    
    func testGetExchangeProgress() {
        subject = ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceSuccess(validResponse: ExchangeProgressMocks.ExchangeProgressJson)
            ),
            ExecutorImpl()
        )
        let submissionResult = VCLSubmissionResult(exchangeToken: VCLToken(value: ""), exchange: VCLExchange(), jti: "", submissionId: "")
        let exchangeDescriptor = VCLExchangeDescriptor(
            presentationSubmission: VCLPresentationSubmission(
                presentationRequest: PresentationRequestMocks.PresentationRequest,
                verifiableCredentials: []
            ), submissionResult: submissionResult
        )

        subject.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) { [weak self] in
            do {
                let exchange = try $0.get()
                assert(exchange == self?.expectedExchange(exchangeJsonDict: ExchangeProgressMocks.ExchangeProgressJson.toDictionary()!))
            } catch {
                XCTFail("\(error)")
            }
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
