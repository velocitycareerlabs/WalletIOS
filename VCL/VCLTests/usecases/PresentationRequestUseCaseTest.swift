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
    
    private var subject1: PresentationRequestUseCase!
    private var subject2: PresentationRequestUseCase!
    
    func testGetPresentationRequestSuccess() {
        let pushUrl = "push_url"
        let pushToken = "push_token"
        subject1 = PresentationRequestUseCaseImpl(
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
            EmptyExecutor()
        )
        subject1.getPresentationRequest(
            presentationRequestDescriptor: VCLPresentationRequestDescriptor(
                deepLink: DeepLinkMocks.PresentationRequestDeepLinkDevNet,
                pushDelegate: VCLPushDelegate(
                    pushUrl: pushUrl,
                    pushToken: pushToken
                ),
                didJwk: DidJwkMocks.DidJwk,
                remoteCryptoServicesToken: VCLToken(value: "some token")
            )
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
                assert(presentationRequest.didJwk.did == DidJwkMocks.DidJwk.did)
                assert(presentationRequest.remoteCryptoServicesToken?.value == "some token")
            } catch {
                XCTFail("\(error)")
            }
        }
    }
    
    func testGetPresentationRequestFailure() {
        subject2 = PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceSuccess(validResponse: "wrong payload")
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceSuccess(validResponse: PresentationRequestMocks.JWK)
            ),
            JwtServiceRepositoryImpl(
                VCLJwtSignServiceLocalImpl(VCLKeyServiceLocalImpl(secretStore: SecretStoreMock.Instance)),
                VCLJwtVerifyServiceLocalImpl()
            ),
            PresentationRequestByDeepLinkVerifierImpl(),
            EmptyExecutor()
        )
        subject2.getPresentationRequest(
            presentationRequestDescriptor: VCLPresentationRequestDescriptor(
                deepLink: DeepLinkMocks.PresentationRequestDeepLinkDevNet,
                didJwk: DidJwkMocks.DidJwk
            )
        ) {
            do  {
                let _ = try $0.get()
                XCTFail("\(VCLErrorCode.SdkError.rawValue) error code is expected")
            }
            catch {
                assert((error as! VCLError).errorCode == VCLErrorCode.SdkError.rawValue)
            }
        }
    }
}
