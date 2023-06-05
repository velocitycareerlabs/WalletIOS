//
//  JwtServiceUseCaseImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

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
        executor.runOnBackground { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(JwtServiceUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                _self.jwtServiceRepository.verifyJwt(jwt: jwt, jwkPublic: jwkPublic) { isVeriviedResult in
                    _self.executor.runOnMain { completionBlock(isVeriviedResult) }
                }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
    
    func generateSignedJwt(
        kid: String? = nil,
        nonce: String? = nil,
        jwtDescriptor: VCLJwtDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwt>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.jwtServiceRepository.generateSignedJwt(
                kid: kid,
                nonce: nonce,
                jwtDescriptor: jwtDescriptor
            ) { jwtResult in
                self?.executor.runOnMain { completionBlock(jwtResult) }
            }
        }
    }
}
