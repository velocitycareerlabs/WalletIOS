//
//  CredentialManifestUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialManifestUseCaseImpl: CredentialManifestUseCase {
    
    private let credentialManifestRepository: CredentialManifestRepository
    private let resolveDidDocumentRepository: ResolveDidDocumentRepository
    private let jwtServiceRepository: JwtServiceRepository
    private let credentialManifestByDeepLinkVerifier: CredentialManifestByDeepLinkVerifier
    private let executor: Executor
    
    init(
        _ credentialManifestRepository: CredentialManifestRepository,
        _ resolveDidDocumentRepository: ResolveDidDocumentRepository,
        _ jwtServiceRepository: JwtServiceRepository,
        _ credentialManifestByDeepLinkVerifier: CredentialManifestByDeepLinkVerifier,
        _ executor: Executor
    ) {
        self.credentialManifestRepository = credentialManifestRepository
        self.resolveDidDocumentRepository = resolveDidDocumentRepository
        self.jwtServiceRepository = jwtServiceRepository
        self.credentialManifestByDeepLinkVerifier = credentialManifestByDeepLinkVerifier
        self.executor = executor
    }
    
    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        verifiedProfile: VCLVerifiedProfile,
        completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        executor.runOnBackground { [weak self] in
            self?.credentialManifestRepository.getCredentialManifest(
                credentialManifestDescriptor: credentialManifestDescriptor
            ) {
                [weak self] credentialManifestResult in
                guard let self = self else { return }
                do {
                    self.resolveDidDocument(
                        VCLCredentialManifest(
                            jwt: VCLJwt(encodedJwt: try credentialManifestResult.get()),
                            vendorOriginContext: credentialManifestDescriptor.vendorOriginContext,
                            verifiedProfile: verifiedProfile,
                            deepLink: credentialManifestDescriptor.deepLink,
                            didJwk: credentialManifestDescriptor.didJwk,
                            remoteCryptoServicesToken: credentialManifestDescriptor.remoteCryptoServicesToken
                        ),
                        completionBlock
                    )
                } catch {
                    self.onError(error, completionBlock)
                }
            }
        }
    }
    
    private func resolveDidDocument(
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let kid = credentialManifest.jwt.kid {
            resolveDidDocumentRepository.resolveDidDocument(did: credentialManifest.iss) { [weak self] didDocumentResult in
                do {
                    let didDocument = try didDocumentResult.get()
                    if let publicJwk = didDocument.getPublicJwk(kid: kid) {
                        self?.verifyCredentialManifestJwt(
                            publicJwk,
                            credentialManifest,
                            didDocument,
                            completionBlock
                        )
                    } else {
                        self?.onError(
                            VCLError(error: "public jwk not found for kid: \(kid)"),
                            completionBlock
                        )
                    }
                } catch {
                    self?.onError(error, completionBlock)
                }
            }
        } else {
            self.onError(
                VCLError(error: "Empty credentialManifest.jwt.kid in jwt: \(credentialManifest.jwt)"),
                completionBlock
            )
        }
    }
    
    private func verifyCredentialManifestJwt(
        _ publicJwk: VCLPublicJwk,
        _ credentialManifest: VCLCredentialManifest,
        _ didDocument: VCLDidDocument,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        jwtServiceRepository.verifyJwt(
            jwt: credentialManifest.jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: credentialManifest.remoteCryptoServicesToken
        ) { [weak self] verificationResult in
            do {
                _ = try verificationResult.get()
                self?.verifyCredentialManifestByDeepLink(
                    credentialManifest,
                    didDocument,
                    completionBlock
                )
            } catch {
                self?.onError(error, completionBlock)
            }
        }
    }
    
    private func verifyCredentialManifestByDeepLink(
        _ credentialManifest: VCLCredentialManifest,
        _ didDocument: VCLDidDocument,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if let deepLink = credentialManifest.deepLink {
            credentialManifestByDeepLinkVerifier.verifyCredentialManifest(
                credentialManifest: credentialManifest,
                deepLink: deepLink,
                didDocument: didDocument
            ) { [weak self] in
                do {
                    let isVerified = try $0.get()
                    VCLLog.d(
                        "Credential manifest deep link verification result: \(isVerified)"
                    )
                    self?.onVerificationSuccess(
                        isVerified,
                        credentialManifest,
                        completionBlock
                    )
                }
                catch {
                    self?.onError(error, completionBlock)
                }
            }
        } else {
            VCLLog.d("Deep link was not provided => nothing to verify")
            executor.runOnMain {
                completionBlock(VCLResult.success(credentialManifest))
            }
        }
    }
    
    private func onVerificationSuccess(
        _ isVerified: Bool,
        _ credentialManifest: VCLCredentialManifest,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        if (isVerified) {
            executor.runOnMain {
                completionBlock(VCLResult.success(credentialManifest))
            }
        } else {
            onError(
                VCLError(error: "Failed to verify credentialManifest jwt:\n\(credentialManifest.jwt)"),
                completionBlock
            )
        }
    }
    
    private func onError(
        _ error: Error,
        _ completionBlock: @escaping (VCLResult<VCLCredentialManifest>) -> Void
    ) {
        executor.runOnMain {
            completionBlock(.failure(VCLError(error: error)))
        }
    }
}
