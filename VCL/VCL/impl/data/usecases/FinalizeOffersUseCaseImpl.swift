//
//  FinalizeOffersUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class FinalizeOffersUseCaseImpl: FinalizeOffersUseCase {
    
    private let finalizeOffersRepository: FinalizeOffersRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let credentialIssuerVerifier: CredentialIssuerVerifier
    private let credentialDidVerifier: CredentialDidVerifier
    private let executor: Executor
    
    init(
        _ finalizeOffersRepository: FinalizeOffersRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ credentialIssuerVerifier: CredentialIssuerVerifier,
        _ credentialDidVerifier: CredentialDidVerifier,
        _ executor: Executor
    ) {
        self.finalizeOffersRepository = finalizeOffersRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.credentialDidVerifier = credentialDidVerifier
        self.credentialIssuerVerifier = credentialIssuerVerifier
        self.executor = executor
    }
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        didJwk: VCLDidJwk? = nil,
        token: VCLToken,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        executor.runOnBackground {
            self.jwtServiceRepository.generateSignedJwt(
                kid: didJwk?.kid,
                nonce: finalizeOffersDescriptor.offers.challenge,
                jwtDescriptor: VCLJwtDescriptor(
                    keyId: didJwk?.keyId,
                    iss: didJwk?.value ?? UUID().uuidString,
                    aud: finalizeOffersDescriptor.issuerId
                )
            ) { [weak self] proofJwtResult in
                do {
                    let proof = try proofJwtResult.get()
                    self?.finalizeOffersRepository.finalizeOffers(
                        token: token,
                        proof: proof,
                        finalizeOffersDescriptor: finalizeOffersDescriptor
                    ) { encodedJwtCredentialsListResult in
                        do {
                            let encodedJwtCredentialsList = try encodedJwtCredentialsListResult.get()
                            self?.verifyCredentialsByIssuer(
                                encodedJwtCredentialsList,
                                finalizeOffersDescriptor
                            ) {
                                do {
                                    let _ = try $0.get()
                                    self?.verifyCredentialByDid(
                                        encodedJwtCredentialsList,
                                        finalizeOffersDescriptor
                                    ) { jwtVerifiableCredentialsResult in
                                        self?.executor.runOnMain {
                                            completionBlock(jwtVerifiableCredentialsResult)
                                        }
                                    }
                                } catch {
                                    self?.onError(VCLError(error: error), completionBlock)
                                }
                            }
                        } catch {
                            self?.onError(VCLError(error: error), completionBlock)
                        }
                    }
                } catch {
                    self?.onError(VCLError(error: error), completionBlock)
                }
            }
        }
    }

    private func verifyCredentialsByIssuer(
        _ encodedJwtCredentialsList: [String],
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        credentialIssuerVerifier.verifyCredentials(
            jwtEncodedCredentials: encodedJwtCredentialsList,
            finalizeOffersDescriptor: finalizeOffersDescriptor
        ) { credentialIssuerVerifierResult in
            do {
                completionBlock(VCLResult.success(try credentialIssuerVerifierResult.get()))
            } catch {
                completionBlock(VCLResult.failure(VCLError(error: error)))
            }
        }
    }

    private func verifyCredentialByDid(
        _ encodedJwtCredentialsList: [String],
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        self.credentialDidVerifier.verifyCredentials(
            jwtEncodedCredentials: encodedJwtCredentialsList,
            finalizeOffersDescriptor: finalizeOffersDescriptor
        ) { jwtVerifiableCredentialsResult in
            do {
                completionBlock(VCLResult.success(try jwtVerifiableCredentialsResult.get()))
            } catch {
                completionBlock(VCLResult.failure(VCLError(error: error)))
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
