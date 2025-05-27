//
//  SubmissionUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class SubmissionUseCaseTest: XCTestCase {
    
    private var subject: SubmissionUseCase!
    
    private let authToken = TokenMocks.AuthToken
    private var didJwk: VCLDidJwk!
    private let keyService = VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)

    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self?.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSubmitPresentationSuccess() {
        subject = PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationSubmissionMocks.PresentationSubmissionResultJson)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(keyService),
                VCLJwtVerifyServiceLocalImpl()
            ),
            EmptyExecutor()
        )
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: VCLPresentationRequest(
                jwt: CommonMocks.JWT, 
                verifiedProfile: VCLVerifiedProfile(payload: [:]),
                deepLink: VCLDeepLink(value: ""),
                didJwk: didJwk
            ),
            verifiableCredentials: [VCLVerifiableCredential]()
        )
        let expectedSubmissionResult =
        expectedSubmissionResult(
            PresentationSubmissionMocks.PresentationSubmissionResultJson.toDictionary()!,
            presentationSubmission.jti, submissionId: presentationSubmission.submissionId
        )
        
        subject.submit(
            submission: presentationSubmission
        ) {
            do {
                let presentationSubmissionResult = try $0.get()
                
                assert(presentationSubmissionResult.sessionToken.value == expectedSubmissionResult.sessionToken.value)
                assert(presentationSubmissionResult.exchange.id == expectedSubmissionResult.exchange.id)
                assert(presentationSubmissionResult.jti == expectedSubmissionResult.jti)
                assert(presentationSubmissionResult.submissionId == expectedSubmissionResult.submissionId)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSubmitPresentationTypeFeedSuccess() {
        subject = PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationSubmissionMocks.PresentationSubmissionResultJson)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(keyService),
                VCLJwtVerifyServiceLocalImpl()
            ),
            EmptyExecutor()
        )
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: VCLPresentationRequest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: [:]),
                deepLink: VCLDeepLink(value: ""),
                didJwk: didJwk
            ),
            verifiableCredentials: [VCLVerifiableCredential]()
        )
        let expectedSubmissionResult =
        expectedSubmissionResult(
            PresentationSubmissionMocks.PresentationSubmissionResultJson.toDictionary()!,
            presentationSubmission.jti, submissionId: presentationSubmission.submissionId
        )
        
        subject.submit(
            submission: presentationSubmission,
            authToken: authToken
        ) {
            do {
                let presentationSubmissionResult = try $0.get()
                
                assert(presentationSubmissionResult.sessionToken.value == expectedSubmissionResult.sessionToken.value)
                assert(presentationSubmissionResult.exchange.id == expectedSubmissionResult.exchange.id)
                assert(presentationSubmissionResult.jti == expectedSubmissionResult.jti)
                assert(presentationSubmissionResult.submissionId == expectedSubmissionResult.submissionId)
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
