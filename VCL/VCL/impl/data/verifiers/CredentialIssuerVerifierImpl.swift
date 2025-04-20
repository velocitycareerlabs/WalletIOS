//
//  CredentialIssuerVerifierImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

actor GlobalErrorStorage {
    private var error: VCLError? = nil
    
    func update(_ error: VCLError) {
        self.error = error
    }
    
    func get() -> VCLError? { return self.error }
}

actor CompleteContextsStorage {
    private var completeContexts = [[String: Any]]()
    
    func append(_ completeContext: [String: Any]) {
        completeContexts.append(completeContext)
    }
    
    func isEmpty() -> Bool {
        return completeContexts.isEmpty
    }
    
    func get() -> [[String: Any]] { return completeContexts }
}

actor IsCredentialVerifiedStorage {
    private var isVerified = false
    
    func update(_ value: Bool) { self.isVerified = value }
    
    func get() -> Bool { return isVerified }
}

final class CredentialIssuerVerifierImpl: CredentialIssuerVerifier {
    
    private let credentialTypesModel: CredentialTypesModel
    private let networkService: NetworkService
    
    private let executor: Executor
        
    private let mainDispatcher: DispatchGroup
    private let resolveContextDispatcher: DispatchGroup
    private let completeContextDispatcher: DispatchGroup
    
    init(
        _ credentialTypesModel: CredentialTypesModel,
        _ networkService: NetworkService,
        _ executor: Executor,
        _ mainDispatcher: DispatchGroup = DispatchGroup(),
        _ resolveContextDispatcher: DispatchGroup = DispatchGroup(),
        _ completeContextDispatcher: DispatchGroup = DispatchGroup()
    ) {
        self.credentialTypesModel = credentialTypesModel
        self.networkService = networkService
        self.executor = executor
        self.mainDispatcher = mainDispatcher
        self.resolveContextDispatcher = resolveContextDispatcher
        self.completeContextDispatcher = completeContextDispatcher
    }
    
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (jwtCredentials.isEmpty) /* nothing to verify */ {
            completionBlock(VCLResult.success(true))
        }
        else if (finalizeOffersDescriptor.serviceTypes.all.isEmpty) {
            completionBlock(VCLResult.failure(VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue)))
        } else {
            let globalError = GlobalErrorStorage()

            jwtCredentials.forEach { jwtCredential in
                executor.runOnBackground { [weak self] in
                    
                    if let credentialTypeName = VerificationUtils.getCredentialType(jwtCredential) {
                        if let credentialType = self?.credentialTypesModel.credentialTypeByTypeName(type: credentialTypeName) {
                            
                            self?.mainDispatcher.enter()
                            self?.verifyCredential(
                                jwtCredential,
                                credentialType,
                                finalizeOffersDescriptor.serviceTypes
                            ) { [weak self] result in
                                do {
                                    let isVerified = try result.get()
                                    VCLLog.d("Credential verification result = \(isVerified)")
                                } catch {
                                    if let e = error as? VCLError {
                                        Task {
                                            await globalError.update(e)
                                        }
                                    } else {
                                        Task {
                                            await globalError.update(VCLError(
                                                payload: "\(error)",
                                                errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure.rawValue
                                            ))
                                        }
                                    }
                                }
                                self?.mainDispatcher.leave()
                            }
                        } else {
                            Task {
                                await globalError.update(VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue))
                            }
                        }
                    } else {
                        Task {
                            await globalError.update(VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue))
                            
                        }
                    }
                }
            }
            mainDispatcher.notify(queue: DispatchQueue.global(), execute: {
                Task {
                    // if at least one credential verification failed => the whole process fails
                    if let e = await globalError.get() {
                        completionBlock(.failure(e))
                    } else {
                        completionBlock(.success(true))
                    }
                }
            })
        }
    }
    
    func verifyCredential(
        _ jwtCredential: VCLJwt,
        _ credentialType: VCLCredentialType,
        _ serviceTypes: VCLServiceTypes,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (
            serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer) ||
            serviceTypes.contains(serviceType: VCLServiceType.IdDocumentIssuer) ||
            serviceTypes.contains(serviceType: VCLServiceType.NotaryIdDocumentIssuer) ||
            serviceTypes.contains(serviceType: VCLServiceType.NotaryContactIssuer) ||
            serviceTypes.contains(serviceType: VCLServiceType.ContactIssuer)
        ) {
            verifyIdentityIssuer(
                credentialType,
                completionBlock
            )
        } else {
            verifyRegularIssuer(
                jwtCredential,
                serviceTypes,
                completionBlock
            )
        }
    }
    
    func verifyIdentityIssuer(
        _ credentialType: VCLCredentialType,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (
            credentialType.issuerCategory == VCLServiceType.IdentityIssuer.rawValue ||
            credentialType.issuerCategory == VCLServiceType.IdDocumentIssuer.rawValue ||
            credentialType.issuerCategory == VCLServiceType.NotaryIdDocumentIssuer.rawValue ||
            credentialType.issuerCategory == VCLServiceType.NotaryContactIssuer.rawValue ||
            credentialType.issuerCategory == VCLServiceType.ContactIssuer.rawValue
        ) {
            completionBlock(VCLResult.success(true))
        } else {
            onError(
                VCLError(errorCode: VCLErrorCode.IssuerRequiresIdentityPermission.rawValue),
                completionBlock
            )
        }
    }
    
    func verifyRegularIssuer(
        _ jwtCredential: VCLJwt,
        _ permittedServiceCategory: VCLServiceTypes,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (permittedServiceCategory.contains(serviceType: VCLServiceType.NotaryIssuer)) {
            completionBlock(VCLResult.success(true))
        } else if (permittedServiceCategory.contains(serviceType: VCLServiceType.Issuer)) {
            if let credentialSubject = VerificationUtils.getCredentialSubjectFromCredential(jwtCredential) {
                if let credentialSubjectContexts = VerificationUtils.getContextsFromCredential(jwtCredential) {
                    resolveCredentialSubjectContexts(credentialSubjectContexts) { [weak self] credentialSubjectContextsResult in
                            do {
                                let completeContexts = try credentialSubjectContextsResult.get()
                                self?.onResolveCredentialSubjectContexts(
                                    credentialSubject,
                                    jwtCredential,
                                    completeContexts,
                                    self,
                                    completionBlock
                                )
                            }
                            catch {
                                self?.onError(
                                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
                                    completionBlock
                                )
                            }
                    }
                } else {
                    onError(
                        VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
                        completionBlock
                    )
                }
            } else {
                onError(
                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
                    completionBlock
                )
            }
        } else {
            onError(
                VCLError(errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure.rawValue),
                completionBlock
            )
        }
    }
    
    private func resolveCredentialSubjectContexts(
        _ credentialSubjectContexts: [String],
        _ completionBlock: @escaping (VCLResult<[[String: Any]]>) -> Void
    ) {
        let completeContextsStorage = CompleteContextsStorage()
        
        credentialSubjectContexts.forEach { [weak self] credentialSubjectContext in
            guard let self = self else { return }
            self.resolveContextDispatcher.enter()
            self.executor.runOnBackground {
                self.networkService.sendRequest(
                    endpoint: credentialSubjectContext,
                    method: Request.HttpMethod.GET,
                    headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
                ) { [weak self] result in
                    guard let self = self else { return }
                    do {
                        if let ldContextResponse = try result.get().payload.toDictionary() {
                            Task {
                                await completeContextsStorage.append(ldContextResponse)
                            }
                        } else {
                            VCLLog.e("Unexpected LD-Context payload.")
                        }
                    } catch {
                        VCLLog.e("Error fetching \(credentialSubjectContext):\n\(error)")
                    }
                    self.resolveContextDispatcher.leave()
                }
            }
        }
        
        self.resolveContextDispatcher.notify(queue: DispatchQueue.global(), execute: {
            Task { [weak self] in
                guard let self = self else { return }
                
                if await completeContextsStorage.isEmpty() {
                    self.onError(
                        VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
                        completionBlock
                    )
                } else {
                    completionBlock(VCLResult.success(await completeContextsStorage.get()))
                }
            }
        })
    }
    
    private func onResolveCredentialSubjectContexts(
        _ credentialSubject: [String: Any],
        _ jwtCredential: VCLJwt,
        _ completeContexts: [[String: Any]],
        _ self: CredentialIssuerVerifierImpl?,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let credentialSubjectType = (((credentialSubject[CodingKeys.KeyType] as? [Any])?[0] as? String) ?? credentialSubject[CodingKeys.KeyType] as? String) {
            let globalErrorStorage = GlobalErrorStorage()
            let isCredentialVerifiedStorage = IsCredentialVerifiedStorage()

            completeContexts.forEach { [weak self] completeContext in
                guard let self = self else { return }
                
                self.completeContextDispatcher.enter()
                self.executor.runOnBackground {
                    
                    let activeContext = (((completeContext[CodingKeys.KeyContext] as? [String: Any])?[credentialSubjectType] as? [String: Any]))?[CodingKeys.KeyContext] as? [String: Any] ?? completeContext
                    if let K = self.findKeyForPrimaryOrganizationValue(activeContext) {
                        if let did = VerificationUtils.getIdentifier(K, credentialSubject) {
                            //  Comparing issuer.id instead of iss
                            //  https://velocitycareerlabs.atlassian.net/browse/VL-6178?focusedCommentId=46933
                            //  https://velocitycareerlabs.atlassian.net/browse/VL-6988
                            //  if (jwtCredential.iss == did)
                            let credentialIssuerId = VerificationUtils.getCredentialIssuerId(jwtCredential: jwtCredential)
                            VCLLog.d("Comparing credentialIssuerId: \(credentialIssuerId ?? "") with did: \(did)")
                            if (credentialIssuerId == did) {
                                Task {
                                    await isCredentialVerifiedStorage.update(true)
                                    self.completeContextDispatcher.leave()
                                }
                            } else {
                                Task {
                                    await globalErrorStorage.update(VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission.rawValue))
                                }
                                self.completeContextDispatcher.leave()
                            }
                        } else {
                            Task {
                                await globalErrorStorage.update(VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission.rawValue))
                            }
                            VCLLog.e("DID NOT FOUND for K = \(K) and credentialSubject = \(credentialSubject)")
                            
                            self.completeContextDispatcher.leave()
                        }
                    } else {
                        Task {
                            // When K is null, the credential will pass these checks:
                            // https://velocitycareerlabs.atlassian.net/browse/VL-6181?focusedCommentId=44343
                            await isCredentialVerifiedStorage.update(true)
                            
                            VCLLog.d("Key for primary organization NOT FOUND for active context:\n\(activeContext)")
                            
                            self.completeContextDispatcher.leave()
                        }
                    }
                }
            }
            completeContextDispatcher.notify(queue: DispatchQueue.global(), execute: {
                Task {
                    if let globalError = await globalErrorStorage.get() {
                        completionBlock(.failure(globalError))
                    } else {
                        if await isCredentialVerifiedStorage.get() {
                            completionBlock(.success(true))
                        } else {
                            completionBlock(
                                .failure(VCLError(errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure.rawValue))
                            )
                        }
                    }
                }
            })
             
        } else {
            self?.onError(
                VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectType.rawValue),
                completionBlock
            )
        }
    }
    
    private func findKeyForPrimaryOrganizationValue(
        _ activeContext: [String: Any]
    ) -> String? {
        for (key, value) in activeContext {
            if let valueMap = value as? [String: Any] {
                if (valueMap[CodingKeys.KeyId] as? String == CodingKeys.ValPrimaryOrganization || 
                    valueMap[CodingKeys.KeyId] as? String == CodingKeys.ValPrimarySourceProfile) {
                    return key
                }
            }
        }
        return nil
    }
    
    func onError<T>(
        _ error: VCLError,
        _ completionBlock: (VCLResult<T>) -> Void
    ) {
        completionBlock(VCLResult.failure(error))
    }
    
    public struct CodingKeys {
        static let KeyVC = "vc"
        static let KeyType = "type"
        
        static let KeyCredentialSubject = "credentialSubject"
        static let KeyContext = "@context"
        static let KeyId = "@id"
        static let KeyIdentifier = "identifier"
        
        static let ValPrimaryOrganization =
            "https://velocitynetwork.foundation/contexts#primaryOrganization"
        static let ValPrimarySourceProfile =
            "https://velocitynetwork.foundation/contexts#primarySourceProfile"
    }
}
