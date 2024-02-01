//
//  ProfileServiceTypeVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/02/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class ProfileServiceTypeVerifierTest: XCTestCase {

    private var subject1: ProfileServiceTypeVerifier!
    private var subject2: ProfileServiceTypeVerifier!
    private var subject3: ProfileServiceTypeVerifier!
    private var subject4: ProfileServiceTypeVerifier!
    private var subject5: ProfileServiceTypeVerifier!
    private var subject6: ProfileServiceTypeVerifier!

    override func setUp() {
        subject1 = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
                ),
                ExecutorImpl()
            )
        )
        subject2 = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileInspectorJsonStr)
                ),
                ExecutorImpl()
            )
        )
        subject3 = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
                ),
                ExecutorImpl()
            )
        )
        subject4 = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
                ),
                ExecutorImpl()
            )
        )
        subject5 = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1)
                ),
                ExecutorImpl()
            )
        )
        subject6 = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
                ),
                ExecutorImpl()
            )
        )
    }
    
    func testVerificationSuccess1() {
        subject1.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Career),
            successHandler: {_ in
                assert(true)
            },
            errorHandler: { error in
                XCTFail("\(error)")
            }
        )
    }

    func testVerificationSuccess2() {
        subject2.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Inspector),
            successHandler: {_ in
                assert(true)
            },
            errorHandler: { error in
                XCTFail("\(error)")
            }
        )
    }

    func testVerificationSuccess3() {
        subject3.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Career),
            successHandler: {_ in
                assert(true)
            },
            errorHandler: { error in
                XCTFail("\(error)")
            }
        )
    }

    func testVerificationFailure1() {
        subject4.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Identity),
            successHandler: {_ in
                XCTFail()
            },
            errorHandler: { error in
                assert(error.statusCode == VCLStatusCode.VerificationError.rawValue)
                assert(error.message!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }

    func testVerificationFailure2() {
        subject5.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Identity),
            successHandler: {_ in
                XCTFail()
            },
            errorHandler: { error in
                assert(error.statusCode == VCLStatusCode.VerificationError.rawValue)
                assert(error.message!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }

    func testVerificationFailure3() {
        subject6.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Undefined),
            successHandler: {_ in
                XCTFail()
            },
            errorHandler: { error in
                assert(error.statusCode == VCLStatusCode.VerificationError.rawValue)
                assert(error.message!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }
}
