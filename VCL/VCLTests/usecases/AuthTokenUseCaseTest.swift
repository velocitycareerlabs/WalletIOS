//
//  AuthTokenUseCaseTest.swift
//  VCL
//
//  Created by Michael Avoyan on 27/04/2025.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class AuthTokenUseCaseTest: XCTestCase {
    var subject: AuthTokenUseCase!
    
    private let expectedAuthToken = TokenMocks.AuthToken
    private let expectedAuthTokenStr = TokenMocks.AuthTokenStr
    
    func testGetAuthTokenSuccess() {
        subject = AuthTokenUseCaseImpl(
            AuthTokenRepositoryImpl(
                NetworkServiceSuccess(validResponse: expectedAuthTokenStr)
            ),
            EmptyExecutor()
        )
        
        subject.getAuthToken(
            authTokenDescriptor: VCLAuthTokenDescriptor(
                authTokenUri: "",
                walletDid: "wallet did",
                relyingPartyDid: "relying party did"
            )) {
                do {
                    let authToken = try $0.get()
                    assert(authToken.payload == TokenMocks.AuthToken.payload)
                    assert(authToken.accessToken.value == self.expectedAuthToken.accessToken.value)
                    assert(authToken.refreshToken.value == self.expectedAuthToken.refreshToken.value)
                    assert(authToken.walletDid == self.expectedAuthToken.walletDid)
                    assert(authToken.relyingPartyDid == self.expectedAuthToken.relyingPartyDid)
                } catch {
                    XCTFail("\(error)")
                }
            }
    }
    
    func testGetAuthTokenFailure() {
        subject = AuthTokenUseCaseImpl(
            AuthTokenRepositoryImpl(
                NetworkServiceSuccess(validResponse: "Wrong payload")
            ),
            EmptyExecutor()
        )
        
        subject.getAuthToken(
            authTokenDescriptor: VCLAuthTokenDescriptor(authTokenUri: "")) {
                do {
                    let _ = try $0.get()
                    XCTFail("\(VCLErrorCode.SdkError.rawValue) error code is expected")
                } catch {
                    assert((error as! VCLError).errorCode == VCLErrorCode.SdkError.rawValue)
                }
            }
    }
}

