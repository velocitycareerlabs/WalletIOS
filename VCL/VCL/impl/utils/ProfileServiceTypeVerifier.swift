//
//  ProfileServiceTypeVerifier.swift
//  VCL
//
//  Created by Michael Avoyan on 16/02/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class ProfileServiceTypeVerifier {
    
    private let verifiedProfileUseCase: VerifiedProfileUseCase

    init(verifiedProfileUseCase: VerifiedProfileUseCase) {
        self.verifiedProfileUseCase = verifiedProfileUseCase
    }
    
    func verifyServiceTypeOfVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        expectedServiceTypes: VCLServiceTypes,
        successHandler: @escaping (VCLVerifiedProfile) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        verifiedProfileUseCase.getVerifiedProfile(verifiedProfileDescriptor: verifiedProfileDescriptor) {
            [weak self] verifiedProfileResult in
            do {
                let verifiedProfile = try verifiedProfileResult.get()
                self?.verifyServiceType(
                    verifiedProfile: verifiedProfile,
                    expectedServiceTypes: expectedServiceTypes,
                    successHandler: {
                        successHandler(verifiedProfile)
                    },
                    errorHandler: {
                        errorHandler($0)
                    }
                )
            } catch {
                errorHandler(VCLError(error: error))
            }
        }
    }

    private func verifyServiceType(
        verifiedProfile: VCLVerifiedProfile,
        expectedServiceTypes: VCLServiceTypes,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        if (verifiedProfile.serviceTypes.containsAtLeastOneOf(serviceTypes: expectedServiceTypes)) {
            successHandler()
        }
        else {
            errorHandler(
                VCLError(
                    message: toJasonString(
                        profileName: verifiedProfile.name,
                        message: "Wrong service type - expected: \(expectedServiceTypes.all), found: \(verifiedProfile.serviceTypes.all)"
                    ),
                    statusCode: VCLStatusCode.VerificationError.rawValue
                )
            )
        }
    }

    private func toJasonString(profileName: String?, message: String?) -> String {
        var jsonDict = [String: String]()
        jsonDict["profileName"] = profileName
        jsonDict["message"] = message
        return jsonDict.toJsonString() ?? "\(profileName ?? "") \(message ?? "")"
    }
}
