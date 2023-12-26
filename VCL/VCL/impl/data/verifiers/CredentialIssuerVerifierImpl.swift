//
//  CredentialIssuerVerifierImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import UIKit

class CredentialIssuerVerifierImpl: CredentialIssuerVerifier {
    
    private let credentialTypesModel: CredentialTypesModel
    private let networkService: NetworkService
    
    private var mainBackgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    private var resolveConetxBackgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    private var completeConetxBackgroundTaskIdentifier: UIBackgroundTaskIdentifier!
    
    private let mainDispatcher = DispatchGroup()
    private let resolveConetxDispatcher = DispatchGroup()
    private let completeConetxDispatcher = DispatchGroup()
    
    init(
        _ credentialTypesModel: CredentialTypesModel,
        _ networkService: NetworkService
    ) {
        self.credentialTypesModel = credentialTypesModel
        self.networkService = networkService
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
            completionBlock(VCLResult.failure(VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered)))
        } else {
            var globalError: VCLError? = nil
            self.mainBackgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish mainBackgroundTaskIdentifier") {
                UIApplication.shared.endBackgroundTask(self.mainBackgroundTaskIdentifier!)
                self.mainBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
            jwtCredentials.forEach { jwtCredential in
                mainDispatcher.enter()
                if let credentialTypeName = Utils.getCredentialType(jwtCredential) {
                    if let credentialType = credentialTypesModel.credentialTypeByTypeName(type: credentialTypeName) {
                        verifyCredential(
                            jwtCredential,
                            credentialType,
                            finalizeOffersDescriptor.serviceTypes
                        ) { [weak self] result in
                            do {
                                let isVerified = try result.get()
                                VCLLog.d("Credential verification result = \(isVerified)")
                            } catch {
                                if let e = error as? VCLError {
                                    globalError = e
                                } else {
                                    globalError = VCLError(
                                        payload: "\(error)",
                                        errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure
                                    )
                                }
                            }
                            self?.mainDispatcher.leave()
                        }
                    } else {
                        globalError = VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered)
                    }
                } else {
                    globalError = VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered)
                    mainDispatcher.leave()
                }
            }
            mainDispatcher.notify(queue: DispatchQueue.global(), execute: {
                if let e = globalError { // if at least one credential verification failed => the whole process fails
                    completionBlock(.failure(e))
                } else {
                    completionBlock(.success(true))
                }
            })
            
            UIApplication.shared.endBackgroundTask(mainBackgroundTaskIdentifier)
            mainBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
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
                VCLError(errorCode: VCLErrorCode.IssuerRequiresIdentityPermission),
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
            if let credentialSubject = Utils.getCredentialSubject(jwtCredential) {
                if let credentialSubjectContexts = retrieveContextFromCredentialSubject(credentialSubject) {
                    resolveCredentialSubjectContexts(credentialSubjectContexts, self) { [weak self] credentialSubjectContextsResult in
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
                                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext),
                                    completionBlock
                                )
                            }
                    }
                } else {
                    onError(
                        VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext),
                        completionBlock
                    )
                }
            } else {
                onError(
                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext),
                    completionBlock
                )
            }
        } else {
            onError(
                VCLError(errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure),
                completionBlock
            )
        }
    }
    
    private func retrieveContextFromCredentialSubject(_ credentialSubject: [String: Any]) -> [String]? {
        if let credentialSubjectContexts = credentialSubject[CodingKeys.KeyContext] as? [String] {
            return credentialSubjectContexts
        } else if let credentialSubjectContext = credentialSubject[CodingKeys.KeyContext] as? String {
            return [credentialSubjectContext]
        }
        return nil
    }
    
    private func resolveCredentialSubjectContexts(
        _ credentialSubjectContexts: [String],
        _ _self: CredentialIssuerVerifierImpl,
        _ completionBlock: @escaping (VCLResult<[[String: Any]]>) -> Void
    ) {
        var completeContexts = [[String: Any]]()
        self.resolveConetxBackgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish resolveConetxBackgroundTaskIdentifier") {
            UIApplication.shared.endBackgroundTask(self.resolveConetxBackgroundTaskIdentifier!)
            self.resolveConetxBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        }
        
        credentialSubjectContexts.forEach { [weak self] credentialSubjectContext in
            
            self?.resolveConetxDispatcher.enter()
            
            self?.networkService.sendRequest(
                endpoint: credentialSubjectContext,
                method: Request.HttpMethod.GET,
                headers: [(HeaderKeys.XVnfProtocolVersion, HeaderValues.XVnfProtocolVersion)]
            ) { [weak self] result in
                do {
                    if let ldContextResponse = try result.get().payload.toDictionary() {
                        completeContexts.append(ldContextResponse)
                    } else {
                        VCLLog.e("Unexpected LD-Context payload.")
                    }
                } catch {
                    VCLLog.e("Error fetching \(credentialSubjectContext):\n\(error)")
                }
                self?.resolveConetxDispatcher.leave()
            }
        }
        
        resolveConetxDispatcher.notify(queue: DispatchQueue.global(), execute: {
            if(completeContexts.isEmpty) {
                self.onError(
                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext),
                    completionBlock
                )
            } else {
                completionBlock(VCLResult.success(completeContexts))
            }
        })
        
        UIApplication.shared.endBackgroundTask(resolveConetxBackgroundTaskIdentifier)
        resolveConetxBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    }
    
    private func onResolveCredentialSubjectContexts(
        _ credentialSubject: [String: Any],
        _ jwtCredential: VCLJwt,
        _ completeContexts: [[String: Any]],
        _ _self: CredentialIssuerVerifierImpl?,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let credentialSubjectType = (credentialSubject[CodingKeys.KeyType] as? String) {
            var globalError: VCLError? = nil
            var isCredentialVerified = false
            self.completeConetxBackgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish completeConetxBackgroundTaskIdentifier") {
                UIApplication.shared.endBackgroundTask(self.completeConetxBackgroundTaskIdentifier!)
                self.completeConetxBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
            completeContexts.forEach { completeContext in
                completeConetxDispatcher.enter()
                let activeContext = (((completeContext[CodingKeys.KeyContext] as? [String: Any])?[credentialSubjectType] as? [String: Any]))?[CodingKeys.KeyContext] as? [String: Any] ?? completeContext
                if let K = findKeyForPrimaryOrganizationValue(activeContext) {
                    if let did = Utils.getIdentifier(K, credentialSubject) {
                        if (jwtCredential.iss == did) {
                            isCredentialVerified = true
                            completeConetxDispatcher.leave()
                        } else {
                            globalError =
                            VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission)
                            completeConetxDispatcher.leave()
                        }
                    } else {
                        globalError =
                        VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission)
                        completeConetxDispatcher.leave()
                    }
                } else {
//                    When K is null, the credential will pass these checks:
//                    https://velocitycareerlabs.atlassian.net/browse/VL-6181?focusedCommentId=44343
                    isCredentialVerified = true
                    completeConetxDispatcher.leave()
                }
            }
            completeConetxDispatcher.notify(queue: DispatchQueue.global(), execute: {
                if isCredentialVerified {
                    completionBlock(.success(true))
                } else {
                    completionBlock(.failure(globalError ?? VCLError(errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure)))
                }
            })
            
            UIApplication.shared.endBackgroundTask(mainBackgroundTaskIdentifier)
            mainBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            
        } else {
            _self?.onError(
                VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectType),
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
