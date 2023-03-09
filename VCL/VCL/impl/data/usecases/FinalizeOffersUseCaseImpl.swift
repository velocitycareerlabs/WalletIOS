//
//  FinalizeOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class FinalizeOffersUseCaseImpl: FinalizeOffersUseCase {
    
    private var backgroundTaskIdentifier: UIBackgroundTaskIdentifier!

    private let finalizeOffersRepository: FinalizeOffersRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    private let dispatcher: Dispatcher
    
    init(
        _ finalizeOffersRepository: FinalizeOffersRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ executor: Executor,
        _ dispatcher: Dispatcher
    ) {
        self.finalizeOffersRepository = finalizeOffersRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
        self.dispatcher = dispatcher
    }
    
    func finalizeOffers(
        token: VCLToken,
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        executor.runOnBackgroundThread { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(FinalizeOffersUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                
                var jwtVerifiableCredentials = [VCLJwt]()
                _self.finalizeOffersRepository.finalizeOffers(
                    token: token,
                    finalizeOffersDescriptor: finalizeOffersDescriptor) { encodedJwtOffersListResult in
                        do {
                            let encodedJwts = try encodedJwtOffersListResult.get()
                            encodedJwts.forEach{ encodedJwtOffer in
                                _self.jwtServiceRepository.decode(encodedJwt: encodedJwtOffer) { jwtResult in
                                    do {
                                        let jwt = try jwtResult.get()
                                        jwtVerifiableCredentials.append(jwt)
                                        if(encodedJwts.count == jwtVerifiableCredentials.count) {
                                            _self.executor.runOnMainThread {
                                                completionBlock(.success(VCLJwtVerifiableCredentials(all: jwtVerifiableCredentials)))
                                            }
                                        }
                                    } catch {
                                        _self.onError(VCLError(error: error), completionBlock)
                                    }
                                }
                            }
                            
                            if(encodedJwts.isEmpty) {
                                completionBlock(.success(VCLJwtVerifiableCredentials(all: jwtVerifiableCredentials)))
                            }
                        } catch {
                            _self.onError(VCLError(error: error), completionBlock)
                        }
                    }
                UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            } else {
                completionBlock(.failure(VCLError(description: "self is nil")))
            }
        }
    }
    
    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        executor.runOnMainThread {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
