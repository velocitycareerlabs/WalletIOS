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
    
    private var subject1: ExchangeProgressUseCase!
    private var subject2: ExchangeProgressUseCase!
    
    func testGetExchangeProgressSucces() {
        subject1 = ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceSuccess(validResponse: ExchangeProgressMocks.ExchangeProgressJson)
            ),
            ExecutorImpl()
        )
        let submissionResult = VCLSubmissionResult(sessionToken: VCLToken(value: ""), exchange: VCLExchange(), jti: "", submissionId: "")
        let exchangeDescriptor = VCLExchangeDescriptor(
            presentationSubmission: VCLPresentationSubmission(
                presentationRequest: PresentationRequestMocks.PresentationRequest,
                verifiableCredentials: []
            ), submissionResult: submissionResult
        )

        subject1.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) { [weak self] in
            do {
                let exchange = try $0.get()
                assert(exchange == self?.expectedExchange(exchangeJsonDict: ExchangeProgressMocks.ExchangeProgressJson.toDictionary()!))
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testGetExchangeProgressFailuer() {
        subject2 = ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceSuccess(validResponse: "wrong payload")
            ),
            ExecutorImpl()
        )
        let submissionResult = VCLSubmissionResult(sessionToken: VCLToken(value: ""), exchange: VCLExchange(), jti: "", submissionId: "")
        let exchangeDescriptor = VCLExchangeDescriptor(
            presentationSubmission: VCLPresentationSubmission(
                presentationRequest: PresentationRequestMocks.PresentationRequest,
                verifiableCredentials: []
            ), submissionResult: submissionResult
        )

        subject2.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) {
            do  {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.SdkError.rawValue) error code is expected")
            }
            catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.SdkError.rawValue)
            }
        }
    }
    
    private func expectedExchange(exchangeJsonDict: [String: Sendable]) -> VCLExchange {
        return VCLExchange(
            id: (exchangeJsonDict[VCLExchange.CodingKeys.KeyId] as! String),
            type: (exchangeJsonDict[VCLExchange.CodingKeys.KeyType] as! String),
            disclosureComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyDisclosureComplete] as! Bool),
            exchangeComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyExchangeComplete] as! Bool)
        )
    }
}
