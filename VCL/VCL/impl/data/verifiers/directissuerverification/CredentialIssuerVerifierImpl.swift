//
//  CredentialIssuerVerifierImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class CredentialIssuerVerifierImpl: CredentialIssuerVerifier {
    
    private let credentialTypesModel: CredentialTypesModel
    private let credentialSubjectContextRepository: CredentialSubjectContextRepository
    
    private let verifyQueue = DispatchQueue(
        label: "io.velocitycareerlabs.contexts.verify",
        qos: .userInitiated,
        attributes: .concurrent
    )
    
    private let contextsQueue = DispatchQueue(
        label: "io.velocitycareerlabs.contexts.fetch",
        qos: .userInitiated,
        attributes: .concurrent
    )

    private let checksQueue = DispatchQueue(
        label: "io.velocitycareerlabs.contexts.checks",
        qos: .userInitiated,
        attributes: .concurrent
    )
    
    init(
        _ credentialTypesModel: CredentialTypesModel,
        _ credentialSubjectContextRepository: CredentialSubjectContextRepository
    ) {
        self.credentialTypesModel = credentialTypesModel
        self.credentialSubjectContextRepository = credentialSubjectContextRepository
    }
    
    func verifyCredentials(
        jwtCredentials: [VCLJwt],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        let group = DispatchGroup()
        
        if jwtCredentials.isEmpty {
            completionBlock(.success(true))
            return
        }
        
        if finalizeOffersDescriptor.serviceTypes.all.isEmpty {
            completionBlock(.failure(
                VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue)
            ))
            return
        }
        
        let globalErrorStorage = GlobalErrorStorage()
        
        for jwtCredential in jwtCredentials {
            group.enter()
            
            verifyQueue.async {
                guard
                    let credentialTypeName = VerificationUtils.getCredentialType(jwtCredential),
                    let credentialType = self.credentialTypesModel.credentialTypeByTypeName(type: credentialTypeName)
                else {
                    globalErrorStorage.update(
                        VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue)
                    )
                    group.leave()   // leave here on early error
                    return
                }
                
                self.verifyCredential(
                    jwtCredential,
                    credentialType,
                    finalizeOffersDescriptor.serviceTypes
                ) { result in
                    switch result {
                    case .success(let isVerified):
                        VCLLog.d("Credential verification result = \(isVerified)")
                    case .failure(let error):
                        globalErrorStorage.update(error)
                    }
                    group.leave()   // leave when async verification actually completes
                }
            }
        }
        
        // BLOCK here until all tasks finished
        group.wait()
        
        // Only after all tasks are done, check the error
        if let error = globalErrorStorage.get() {
            // if at least one credential verification failed => the whole process fails
            completionBlock(.failure(error))
        } else {
            completionBlock(.success(true))
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
        let group = DispatchGroup()
        
        let completeContextsStorage = CompleteContextsStorage()
        
//        let credentialSubjectContext = credentialSubjectContexts[0]
        for credentialSubjectContext in credentialSubjectContexts {
            group.enter()
            
            contextsQueue.async { [weak self] in
                guard let strongSelf = self else {
                    group.leave() // always balance enter/leave
                    return
                }
                
                strongSelf.credentialSubjectContextRepository.getCredentialSubjectContext(
                    credentialSubjectContextEndpoint: credentialSubjectContext
                ) { result in
                    VCLLog.d("getCredentialSubjectContext completed for \(credentialSubjectContext)")
                    defer { group.leave() }    // balanced even on error paths
                    do {
                        let ldContextResponse = try result.get()
                        completeContextsStorage.append(ldContextResponse)
                    } catch {
                        VCLLog.e("\(error)")
                    }
                }
            }
        }
        
        // BLOCK here until all fetches are done
        group.wait()
        
        if completeContextsStorage.isEmpty() {
            onError(
                VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
                completionBlock
            )
        } else {
            completionBlock(.success(completeContextsStorage.get()))
        }
    }
    
    private func onResolveCredentialSubjectContexts(
        _ credentialSubject: [String: Any],
        _ jwtCredential: VCLJwt,
        _ completeContexts: [[String: Any]],
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        guard let credentialSubjectType = VerificationUtils.extractCredentialSubjectType(from: credentialSubject) else {
            onError(
                VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectType.rawValue),
                completionBlock
            )
            return
        }
        
        let group = DispatchGroup()
        
        let globalErrorStorage = GlobalErrorStorage()
        let isCredentialVerifiedStorage = IsCredentialVerifiedStorage()
        
        for completeContext in completeContexts {
            group.enter()
            
            checksQueue.async {
                
                defer { group.leave() }
                
                let activeContext = VerificationUtils.extractActiveContext(completeContext, credentialSubjectType)
                
                guard let K = VerificationUtils.findKeyForPrimaryOrganizationValue(activeContext) else {
                    // Case: no primary organization key found → accept
                    // When K is null, the credential will pass these checks:
                    // https://velocitycareerlabs.atlassian.net/browse/VL-6181?focusedCommentId=44343
                    isCredentialVerifiedStorage.update(true)
                    VCLLog.d("No primary organization key in context: \(activeContext)")
                    return
                }
                
                guard let did = VerificationUtils.getIdentifier(K, credentialSubject) else {
                    globalErrorStorage.update(
                        VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission.rawValue)
                    )
                    VCLLog.e("DID not found for K = \(K) and subject = \(credentialSubject)")
                    return
                }
                
                let issuerId = VerificationUtils.getCredentialIssuerId(jwtCredential: jwtCredential)
                VCLLog.d("Comparing credentialIssuerId: \(issuerId ?? "") with did: \(did)")
                
                // Comparing issuer.id instead of iss
                // https://velocitycareerlabs.atlassian.net/browse/VL-6178?focusedCommentId=46933
                // https://velocitycareerlabs.atlassian.net/browse/VL-6988
                // if (jwtCredential.iss == did)
                if issuerId == did {
                    isCredentialVerifiedStorage.update(true)
                } else {
                    globalErrorStorage.update(
                        VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission.rawValue)
                    )
                }
            }
        }
        
        // BLOCK until all context checks are complete
        group.wait()
        
        if let error = globalErrorStorage.get() {
            completionBlock(.failure(error))
        } else if isCredentialVerifiedStorage.get() {
            completionBlock(.success(true))
        } else {
            completionBlock(
                .failure(VCLError(errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure.rawValue))
            )
        }
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
        
        static let ValPrimaryOrganization = "https://velocitynetwork.foundation/contexts#primaryOrganization"
        static let ValPrimarySourceProfile = "https://velocitynetwork.foundation/contexts#primarySourceProfile"
    }
}
