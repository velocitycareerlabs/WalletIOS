//
//  JwtServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class JwtServiceUseCaseImpl: JwtServiceUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!

    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    
    init(_ jwtServiceRepository: JwtServiceRepository, _ executor: Executor) {
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
    }
    
    func verifyJwt(
        jwt: VCLJwt,
        jwkPublic: VCLJwkPublic,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(JwtServiceUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.jwtServiceRepository.verifyJwt(jwt: jwt, jwkPublic: jwkPublic) { isVeriviedResult in
                    _self.executor.runOnMainThread { completionBlock(isVeriviedResult) }
                }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(jwtDescriptor: jwtDescriptor) { isVeriviedResult in
                self?.executor.runOnMainThread { completionBlock(isVeriviedResult) }
            }
        }
    }
    
    func generateDidJwk(
        completionBlock: @escaping (VCLResult<VCLDidJwk>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            self?.jwtServiceRepository.generateDidJwk { didJwkResult in
                self?.executor.runOnMainThread { completionBlock(didJwkResult) }
            }
        }
    }
}
