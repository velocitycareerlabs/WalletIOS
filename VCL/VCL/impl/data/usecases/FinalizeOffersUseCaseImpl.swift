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
    private let credentialsByDeepLinkVerifier: CredentialsByDeepLinkVerifier
    private let executor: Executor
    
    init(
        _ finalizeOffersRepository: FinalizeOffersRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ credentialIssuerVerifier: CredentialIssuerVerifier,
        _ credentialDidVerifier: CredentialDidVerifier,
        _ credentialsByDeepLinkVerifier: CredentialsByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.finalizeOffersRepository = finalizeOffersRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.credentialDidVerifier = credentialDidVerifier
        self.credentialIssuerVerifier = credentialIssuerVerifier
        self.credentialsByDeepLinkVerifier = credentialsByDeepLinkVerifier
        self.executor = executor
    }
    
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            if let challenge = finalizeOffersDescriptor.challenge {
                self?.jwtServiceRepository.generateSignedJwt(
                    jwtDescriptor: VCLJwtDescriptor(
                        iss: finalizeOffersDescriptor.didJwk.did,
                        aud: finalizeOffersDescriptor.aud
                    ),
                    nonce: challenge,
                    didJwk: finalizeOffersDescriptor.didJwk,
                    remoteCryptoServicesToken: finalizeOffersDescriptor.remoteCryptoServicesToken
                ) { proofJwtResult in
                    do {
                        let proof = try proofJwtResult.get()
                        self?.finalizeOffersInvoke(
                            weakSelf: self,
                            finalizeOffersDescriptor: finalizeOffersDescriptor,
                            sessionToken: sessionToken,
                            proof: proof,
                            completionBlock: completionBlock
                        )
                    } catch {
                        self?.onError(VCLError(error: error), completionBlock)
                    }
                }
            } else {
                self?.finalizeOffersInvoke(
                    weakSelf: self,
                    finalizeOffersDescriptor: finalizeOffersDescriptor,
                    sessionToken: sessionToken,
                    completionBlock: completionBlock
                )
            }
        }
    }
    
    private func finalizeOffersInvoke(
        weakSelf: FinalizeOffersUseCaseImpl?,
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        proof: VCLJwt? = nil,
        completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        weakSelf?.finalizeOffersRepository.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptor,
            sessionToken: sessionToken,
            proof: proof
        ) { jwtCredentialsListResult in
            do {
                let jwtCredentials = try jwtCredentialsListResult.get()
                weakSelf?.verifyCredentialsByDeepLink(
                    jwtCredentials,
                    finalizeOffersDescriptor
                ) { verifyCredentialsByDeepLinkResult in
                    do {
                        _ = try verifyCredentialsByDeepLinkResult.get()
                        weakSelf?.verifyCredentialsByIssuer(
                            jwtCredentials,
                            finalizeOffersDescriptor
                        ) { verifyCredentialsByIssuerResult in
                            do {
                                let _ = try verifyCredentialsByIssuerResult.get()
                                weakSelf?.verifyCredentialByDid(
                                    jwtCredentials,
                                    finalizeOffersDescriptor
                                ) { jwtVerifiableCredentialsResult in
                                    weakSelf?.executor.runOnMain {
                                        completionBlock(
                                            jwtVerifiableCredentialsResult
                                        )
                                    }
                                }
                            } catch {
                                weakSelf?.onError(VCLError(error: error), completionBlock)
                            }
                        }
                    } catch {
                        weakSelf?.onError(VCLError(error: error), completionBlock)
                    }
                }
            } catch {
                weakSelf?.onError(VCLError(error: error), completionBlock)
            }
        }
    }
    
    private func verifyCredentialsByDeepLink(
        _ jwtCredentials: [VCLJwt],
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let deepLink = finalizeOffersDescriptor.credentialManifest.deepLink {
            credentialsByDeepLinkVerifier.verifyCredentials(
                jwtCredentials: jwtCredentials,
                deepLink: deepLink
            ) { isVerifiedRes in
                do {
                    VCLLog.d("Credentials by deep link verification result: \(try isVerifiedRes.get())")
                    completionBlock(.success(true))
                } catch {
                    completionBlock(.failure(VCLError(error: error)))
                }
            }
        } else {
            VCLLog.d("Deep link was not provided => nothing to verify")
            completionBlock(.success(true))
        }
    }

    private func verifyCredentialsByIssuer(
        _ jwtCredentials: [VCLJwt],
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        credentialIssuerVerifier.verifyCredentials(
            jwtCredentials: jwtCredentials,
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
        _ jwtCredentials: [VCLJwt],
        _ finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        _ completionBlock: @escaping (VCLResult<VCLJwtVerifiableCredentials>) -> Void
    ) {
        credentialDidVerifier.verifyCredentials(
            jwtCredentials: jwtCredentials,
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
