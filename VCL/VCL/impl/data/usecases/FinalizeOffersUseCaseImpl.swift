//
//  FinalizeOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

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
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        didJwk: VCLDidJwk,
        token: VCLToken,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            if let _self = self {
                _self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish \(FinalizeOffersUseCase.self)") {
                    UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                    _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                }
                _self.jwtServiceRepository.generateSignedJwt(
                    kid: didJwk.kid,
                    nonce: finalizeOffersDescriptor.offers.challenge,
                    jwtDescriptor: VCLJwtDescriptor(
                        iss: didJwk.value,
                        aud: finalizeOffersDescriptor.issuerId
                    )
                ) { proofJwtResult in
                    do {
                        let proof = try proofJwtResult.get()
                        
                        _self.finalizeOffersRepository.finalizeOffers(
                            token: token,
                            proof: proof,
                            finalizeOffersDescriptor: finalizeOffersDescriptor) { encodedJwtOffersListResult in
                                do {
                                    let encodedJwtOffersList = try encodedJwtOffersListResult.get()
                                    _self.verifyCredentials(
                                        encodedJwtOffersList,
                                        finalizeOffersDescriptor,
                                        completionBlock
                                    )
                                } catch {
                                    completionBlock(.failure(VCLError(error: error)))
                                }
                            }
                        UIApplication.shared.endBackgroundTask(_self.backgroundTaskIdentifier!)
                        _self.backgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
                    } catch {
                        completionBlock(.failure(VCLError(error: error)))
                    }
                }
            } else {
                completionBlock(.failure(VCLError(message: "self is nil")))
            }
        }
    }
    
    private func verifyCredentials(
        _ encodedJwts: [String],
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        var passedCredentials = [VCLJwt]()
        var failedCredentials = [VCLJwt]()
        encodedJwts.forEach{ [weak self] encodedJwtOffer in
            self?.jwtServiceRepository.decode(encodedJwt: encodedJwtOffer) { jwtResult in
                do {
                    let jwtCredential = try jwtResult.get()
                    if (self?.verifyJwtCredential(jwtCredential, finalizeOffersDescriptor) == true) {
                        passedCredentials.append(jwtCredential)
                    } else {
                        failedCredentials.append(jwtCredential)
                    }
                    if(encodedJwts.count == passedCredentials.count + failedCredentials.count) {
                        self?.executor.runOnMain {
                            completionBlock(.success(VCLJwtVerifiableCredentials(
                                passedCredentials: passedCredentials,
                                failedCredentials: failedCredentials
                            )))
                        }
                    }
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        }
        if(encodedJwts.isEmpty) {
            completionBlock(.success(VCLJwtVerifiableCredentials(
                passedCredentials: passedCredentials,
                failedCredentials: failedCredentials
            )))
        }
    }
    private func verifyJwtCredential(
        _ jwtCredential: VCLJwt,
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor
    ) -> Bool {
        return jwtCredential.payload?["iss"] as? String == finalizeOffersDescriptor.did
    }
    
    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        executor.runOnMain {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
