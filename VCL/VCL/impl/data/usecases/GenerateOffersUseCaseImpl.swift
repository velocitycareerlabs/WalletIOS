//
//  GenerateOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class GenerateOffersUseCaseImpl: GenerateOffersUseCase {
    
    private let generateOffersRepository: GenerateOffersRepository
    private let offersByDeepLinkVerifier: OffersByDeepLinkVerifier
    private let executor: Executor
    
    init(
        _ generateOffersRepository: GenerateOffersRepository,
        _ offersByDeepLinkVerifier: OffersByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.generateOffersRepository = generateOffersRepository
        self.offersByDeepLinkVerifier = offersByDeepLinkVerifier
        self.executor = executor
    }
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.generateOffersRepository.generateOffers(
                generateOffersDescriptor: generateOffersDescriptor,
                sessionToken: sessionToken
            ) { [weak self] offersResult in
                guard let _ = self else { return }
                do {
                    let offers = try offersResult.get()
                    self?.verifyOffersByDeepLink(
                        offers: offers,
                        generateOffersDescriptor: generateOffersDescriptor,
                        completionBlock: completionBlock
                    )
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        }
    }
    
    private func verifyOffersByDeepLink(
        offers: VCLOffers,
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void
    ) {
        if let deepLink = generateOffersDescriptor.credentialManifest.deepLink {
            offersByDeepLinkVerifier.verifyOffers(offers: offers, deepLink: deepLink) {
                [weak self] in
                do {
                    let isVerified = try $0.get()
                    VCLLog.d("Offers deep link verification result: \(isVerified)")
                    self?.executor.runOnMain {
                        completionBlock(VCLResult.success(offers))
                    }
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        } else {
            VCLLog.d("Deep link was not provided => nothing to verify")
            executor.runOnMain {
                completionBlock(VCLResult.success(offers))
            }
        }
    }
    
    private func onError<T>(
        _ error: VCLError,
        _ completionBlock: @escaping (VCLResult<T>) -> Void
    ) {
        executor.runOnMain { completionBlock(VCLResult.failure(error)) }
    }
}
