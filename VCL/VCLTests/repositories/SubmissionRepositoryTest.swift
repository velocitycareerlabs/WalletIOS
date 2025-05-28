//
//  SubmissionRepositoryTest.swift
//  VCL
//
//  Created by Michael Avoyan on 27/05/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class SubmissionRepositoryTest: XCTestCase {
    private var subject: SpyPresentationSubmissionRepository!

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
        
        subject = SpyPresentationSubmissionRepository(
            NetworkServiceSuccess(validResponse: PresentationSubmissionMocks.PresentationSubmissionResultJson)
        )
    }
    
    func testSubmitPresentationSuccess() {
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: VCLPresentationRequest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: "{}".toDictionary()!),
                deepLink: VCLDeepLink(value: ""),
                didJwk: didJwk
            ),
            verifiableCredentials: []
        )
        let expectedSubmissionResult =
        expectedSubmissionResult(
            PresentationSubmissionMocks.PresentationSubmissionResultJson.toDictionary()!,
            presentationSubmission.jti,
            submissionId: presentationSubmission.submissionId
        )
        
        subject.submit(
            submission: presentationSubmission,
            jwt: CommonMocks.JWT,
            authToken: nil
        ) {
            submissionResult in
            do {
                let submissionResult = try submissionResult.get()
                assert(submissionResult.sessionToken.value == expectedSubmissionResult.sessionToken.value)
                assert(submissionResult.exchange.id == expectedSubmissionResult.exchange.id)
                assert(submissionResult.jti == expectedSubmissionResult.jti)
                assert(submissionResult.submissionId == expectedSubmissionResult.submissionId)
            }
            catch {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(subject.generateHeaderCalled)
        XCTAssertEqual(subject.capturedAuthToken?.value, nil)
    }
    
    func testSubmitPresentationTypeFeedSuccess() {
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: VCLPresentationRequest(
                jwt: CommonMocks.JWT,
                verifiedProfile: VCLVerifiedProfile(payload: "{}".toDictionary()!),
                deepLink: VCLDeepLink(value: ""),
                didJwk: didJwk
            ),
            verifiableCredentials: []
        )
        let expectedSubmissionResult =
        expectedSubmissionResult(
            PresentationSubmissionMocks.PresentationSubmissionResultJson.toDictionary()!,
            presentationSubmission.jti,
            submissionId: presentationSubmission.submissionId
        )
        
        subject.submit(
            submission: presentationSubmission,
            jwt: CommonMocks.JWT,
            authToken: authToken
        ) {
            submissionResult in
            do {
                let submissionResult = try submissionResult.get()
                assert(submissionResult.sessionToken.value == expectedSubmissionResult.sessionToken.value)
                assert(submissionResult.exchange.id == expectedSubmissionResult.exchange.id)
                assert(submissionResult.jti == expectedSubmissionResult.jti)
                assert(submissionResult.submissionId == expectedSubmissionResult.submissionId)
            }
            catch {
                XCTFail("\(error)")
            }
        }
        
        XCTAssertTrue(subject.generateHeaderCalled)
        XCTAssert(subject.capturedAuthToken! == authToken.accessToken)
    }
    
    func testGenerateHeaderWithAuthToken() {
        let header = subject.generateHeader(accessToken: authToken.accessToken)

        assert(header.count == 2)

        assert(header[0].0 == HeaderKeys.XVnfProtocolVersion)
        assert(header[0].1 == HeaderValues.XVnfProtocolVersion)

        assert(header[1].0 == HeaderKeys.Authorization)
        assert(header[1].1 == "\(HeaderValues.PrefixBearer) \(authToken.accessToken.value)")
    }

    func testGenerateHeaderWithoutAuthToken() {
        let header = subject.generateHeader()

        assert(header.count == 1)

        assert(header[0].0 == HeaderKeys.XVnfProtocolVersion)
        assert(header[0].1 == HeaderValues.XVnfProtocolVersion)
    }
}

class SpyPresentationSubmissionRepository: SubmissionRepositoryImpl {
    var generateHeaderCalled = false
    var capturedAuthToken: VCLToken?

    override func generateHeader(accessToken: VCLToken? = nil) -> [(String, String)] {
        generateHeaderCalled = true
        capturedAuthToken = accessToken
        return super.generateHeader(accessToken: accessToken)
    }
}
