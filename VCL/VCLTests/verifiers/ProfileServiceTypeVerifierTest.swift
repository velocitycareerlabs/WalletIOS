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

    private var subject: ProfileServiceTypeVerifier!

    func testVerificationSuccess1() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
                ),
                ExecutorImpl()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Career),
            successHandler: {_ in
                assert(true)
            },
            errorHandler: {_ in
                assert(false)
            }
        )
    }

    func testVerificationSuccess2() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileInspectorJsonStr)
                ),
                ExecutorImpl()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Inspector),
            successHandler: {_ in
                assert(true)
            },
            errorHandler: {_ in
                assert(false)
            }
        )
    }

    func testVerificationSuccess3() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
                ),
                ExecutorImpl()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Career),
            successHandler: {_ in
                assert(true)
            },
            errorHandler: {_ in
                assert(false)
            }
        )
    }

    func testVerificationFailure1() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
                ),
                ExecutorImpl()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Identity),
            successHandler: {_ in
                assert(false)
            },
            errorHandler: { error in
                assert(error.statusCode == VCLStatusCode.VerificationError.rawValue)
                assert(error.message!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }

    func testVerificationFailure2() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr1)
                ),
                ExecutorImpl()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Identity),
            successHandler: {_ in
                assert(false)
            },
            errorHandler: { error in
                assert(error.statusCode == VCLStatusCode.VerificationError.rawValue)
                assert(error.message!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }

    func testVerificationFailure3() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
                ),
                ExecutorImpl()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Undefined),
            successHandler: {_ in
                assert(false)
            },
            errorHandler: { error in
                assert(error.statusCode == VCLStatusCode.VerificationError.rawValue)
                assert(error.message!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }
}
