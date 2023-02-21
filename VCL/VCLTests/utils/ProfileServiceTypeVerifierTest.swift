//
//  ProfileServiceTypeVerifierTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 16/02/2023.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class ProfileServiceTypeVerifierTest: XCTestCase {

    var subject: ProfileServiceTypeVerifier!

    func verificationSuccess1() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
                ),
                EmptyExecutor()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Career),
            successHandler: {
                assert(true)
            },
            errorHandler: {_ in
                assert(false)
            }
        )
    }

    func verificationSuccess2() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileInspectorJsonStr)
                ),
                EmptyExecutor()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Inspector),
            successHandler: {
                assert(true)
            },
            errorHandler: {_ in
                assert(false)
            }
        )
    }

    func verificationSuccess3() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
                ),
                EmptyExecutor()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Career),
            successHandler: {
                assert(true)
            },
            errorHandler: {_ in
                assert(false)
            }
        )
    }

    func verificationFailure1() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileNotaryIssuerJsonStr)
                ),
                EmptyExecutor()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Identity),
            successHandler: {
                assert(false)
            },
            errorHandler: { error in
                assert(error.code == VCLErrorCode.VerificationError.rawValue)
                assert(error.description!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }

    func verificationFailure2() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerJsonStr)
                ),
                EmptyExecutor()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(issuingType: VCLIssuingType.Identity),
            successHandler: {
                assert(false)
            },
            errorHandler: { error in
                assert(error.code == VCLErrorCode.VerificationError.rawValue)
                assert(error.description!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }

    func verificationFailure3() {
        subject = ProfileServiceTypeVerifier(
            verifiedProfileUseCase: VerifiedProfileUseCaseImpl(
                VerifiedProfileRepositoryImpl(
                    NetworkServiceSuccess(validResponse: VerifiedProfileMocks.VerifiedProfileIssuerInspectorJsonStr)
                ),
                EmptyExecutor()
            )
        )

        subject.verifyServiceTypeOfVerifiedProfile(
            verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: ""),
            expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Undefined),
            successHandler: {
                assert(false)
            },
            errorHandler: { error in
                assert(error.code == VCLErrorCode.VerificationError.rawValue)
                assert(error.description!.toDictionary()!["profileName"] as! String == "University of Massachusetts Amherst")
            }
        )
    }
}
