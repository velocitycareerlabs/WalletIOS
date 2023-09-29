//
//  PresentationSubmissionUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class PresentationSubmissionUseCaseTest: XCTestCase {
    
    var subject: PresentationSubmissionUseCase!
    
    var didJwk: VCLDidJwk!
    let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)
    
    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self!.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSubmitPresentationSuccess() {
        // Arrange
        subject = PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationSubmissionMocks.PresentationSubmissionResultJson)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtServiceLocalImpl(keyService)
            ),
            EmptyExecutor()
        )
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: VCLPresentationRequest(
                jwt: CommonMocks.JWT,
                publicJwk: VCLPublicJwk(valueStr: "{}"),
                deepLink: VCLDeepLink(value: "")
            ),
            verifiableCredentials: [VCLVerifiableCredential]()
        )
        var result: VCLResult<VCLSubmissionResult>? = nil
        
        // Action
        subject.submit(
            submission: presentationSubmission,
            didJwk: didJwk
        ) {
            result = $0
        }
        
        let expectedPresentationSubmissionResult =
            expectedPresentationSubmissionResult(
                PresentationSubmissionMocks.PresentationSubmissionResultJson.toDictionary()!,
                presentationSubmission.jti, submissionId: presentationSubmission.submissionId
            )
        
        // Assert
        do {
            let presentationSubmissionResult = try result?.get()
            
            assert(presentationSubmissionResult!.token.value == expectedPresentationSubmissionResult.token.value)
            assert(presentationSubmissionResult!.exchange.id == expectedPresentationSubmissionResult.exchange.id)
            assert(presentationSubmissionResult!.jti == expectedPresentationSubmissionResult.jti)
            assert(presentationSubmissionResult!.submissionId == expectedPresentationSubmissionResult.submissionId)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    private func expectedPresentationSubmissionResult(_ jsonDict: [String: Any], _ jti: String, submissionId: String) -> VCLSubmissionResult {
        let exchangeJsonDict = jsonDict[VCLSubmissionResult.CodingKeys.KeyExchange]
        return VCLSubmissionResult(
            token: VCLToken(value: (jsonDict[VCLSubmissionResult.CodingKeys.KeyToken] as! String)),
            exchange: expectedExchange(exchangeJsonDict as! [String : Any]),
            jti: jti,
            submissionId: submissionId
        )
    }
    
    private func expectedExchange(_ exchangeJsonDict: [String: Any]) -> VCLExchange {
        return VCLExchange(
            id: (exchangeJsonDict[VCLExchange.CodingKeys.KeyId] as! String),
            type: (exchangeJsonDict[VCLExchange.CodingKeys.KeyType] as! String),
            disclosureComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyDisclosureComplete] as! Bool),
            exchangeComplete: (exchangeJsonDict[VCLExchange.CodingKeys.KeyExchangeComplete] as! Bool)
        )
    }
    
    override func tearDown() {
    }
}
