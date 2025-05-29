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
    private var networkServiceSuccessSpy: NetworkServiceSuccessSpy!
    
    private var expectedHeadersWithAccessToken: Array<(String, String)>!
    private var expectedHeadersWithoutAccessToken: Array<(String, String)>!
    
    override func setUp() {
        keyService.generateDidJwk() { [weak self] didJwkResult in
            do {
                self?.didJwk = try didJwkResult.get()
            } catch {
                XCTFail("\(error)")
            }
        }
        
        expectedHeadersWithAccessToken =
        [
            (HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion),
            (HeaderKeys.Authorization, "\(HeaderValues.PrefixBearer) \(authToken.accessToken.value)")
        ]
        expectedHeadersWithoutAccessToken = [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
        
        networkServiceSuccessSpy = NetworkServiceSuccessSpy(validResponse: PresentationSubmissionMocks.PresentationSubmissionResultJson)
        
        subject = PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                networkServiceSuccessSpy
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(keyService),
                VCLJwtVerifyServiceLocalImpl()
            ),
            EmptyExecutor()
        )
    }
    
    func testSubmitPresentationSuccess() {
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
        ) { [self] in
            do {
                let presentationSubmissionResult = try $0.get()
                
                assert(presentationSubmissionResult.sessionToken.value == expectedSubmissionResult.sessionToken.value)
                assert(presentationSubmissionResult.exchange.id == expectedSubmissionResult.exchange.id)
                assert(presentationSubmissionResult.jti == expectedSubmissionResult.jti)
                assert(presentationSubmissionResult.submissionId == expectedSubmissionResult.submissionId)
                
                XCTAssertTrue(networkServiceSuccessSpy.sendRequestCalled)
                XCTAssertTrue(
                    zip(
                        networkServiceSuccessSpy.headersCaptured!,
                        expectedHeadersWithoutAccessToken
                    ).allSatisfy { $0 == $1 } && networkServiceSuccessSpy.headersCaptured!.count == expectedHeadersWithoutAccessToken.count
                )
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testSubmitPresentationTypeFeedSuccess() {
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
        ) { [self] in
            do {
                let presentationSubmissionResult = try $0.get()
                
                assert(presentationSubmissionResult.sessionToken.value == expectedSubmissionResult.sessionToken.value)
                assert(presentationSubmissionResult.exchange.id == expectedSubmissionResult.exchange.id)
                assert(presentationSubmissionResult.jti == expectedSubmissionResult.jti)
                assert(presentationSubmissionResult.submissionId == expectedSubmissionResult.submissionId)
                
                XCTAssertTrue(networkServiceSuccessSpy.sendRequestCalled)
                XCTAssertTrue(
                    zip(
                        networkServiceSuccessSpy.headersCaptured!,
                        expectedHeadersWithAccessToken
                    ).allSatisfy { $0 == $1 } && networkServiceSuccessSpy.headersCaptured!.count == expectedHeadersWithAccessToken.count
                )
                
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}

class NetworkServiceSuccessSpy: NetworkServiceSuccess {
    var sendRequestCalled = false
    var headersCaptured: Array<(String, String)>?

    override func sendRequest(
        endpoint: String,
        body: String?,
        contentType: Request.ContentType,
        method: Request.HttpMethod,
        headers: Array<(String, String)>?,
        cachePolicy: NSURLRequest.CachePolicy,
        completionBlock: @escaping (VCLResult<Response>) -> Void
    ) {
        sendRequestCalled = true
        headersCaptured = headers
        super.sendRequest(
            endpoint: endpoint,
            body: body,
            contentType: contentType,
            method: method,
            headers: headers,
            cachePolicy: cachePolicy,
            completionBlock: completionBlock
        )
    }
}
