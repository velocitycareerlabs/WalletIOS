//
//  FinalizeOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//

import Foundation

class FinalizeOffersUseCaseImpl: FinalizeOffersUseCase {
    
    private let finalizeOffersRepository: FinalizeOffersRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let executor: Executor
    private let dispatcher: Dispatcher
    
    init(_ finalizeOffersRepository: FinalizeOffersRepository,
         _ jwtServiceRepository: JwtServiceRepository,
         _ executor: Executor,
         _ dispatcher: Dispatcher) {
        self.finalizeOffersRepository = finalizeOffersRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.executor = executor
        self.dispatcher = dispatcher
    }
    
    func finalizeOffers(token: VCLToken,
                        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
                        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void) {
        executor.runOnBackgroundThread { [weak self] in
            var jwtVerifiableCredentials = [VCLJWT]()
            self?.finalizeOffersRepository.finalizeOffers(
                token: token,
                finalizeOffersDescriptor: finalizeOffersDescriptor) { encodedJwtOffersListResult in
                do {
                    let encodedJwts = try encodedJwtOffersListResult.get()
                    encodedJwts.forEach{ encodedJwtOffer in
                        self?.jwtServiceRepository.decode(encodedJwt: encodedJwtOffer) { jwtResult in
                            do {
                                let jwt = try jwtResult.get()
                                jwtVerifiableCredentials.append(jwt)
                                if(encodedJwts.count == jwtVerifiableCredentials.count) {
                                    self?.executor.runOnMainThread {
                                        completionBlock(.success(VCLJwtVerifiableCredentials(all: jwtVerifiableCredentials)))
                                    }
                                }
                            } catch {
                                self?.onError(VCLError(error: error), completionBlock)
                            }
                        }
                    }
                    
                    if(encodedJwts.isEmpty) {
                        completionBlock(.success(VCLJwtVerifiableCredentials(all: jwtVerifiableCredentials)))
                    }
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
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
