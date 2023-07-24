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
        jwtEncodedCredentials: [String],
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if (jwtEncodedCredentials.isEmpty) /* nothing to verify */ {
            completionBlock(VCLResult.success(true))
        }
        else if (finalizeOffersDescriptor.serviceTypes.all.isEmpty) {
            completionBlock(VCLResult.failure(VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue)))
        } else {
            var globalError: VCLError? = nil
            
            self.mainBackgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish mainBackgroundTaskIdentifier") {
                UIApplication.shared.endBackgroundTask(self.mainBackgroundTaskIdentifier!)
                self.mainBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
            jwtEncodedCredentials.forEach { encodedJwtCredential in
                mainDispatcher.enter()
                let jwtCredential = VCLJwt(encodedJwt: encodedJwtCredential)
                if let credentialTypeName = Utils.getCredentialType(jwtCredential) {
                    if let credentialType = credentialTypesModel.credentialTypeByTypeName(type: credentialTypeName) {
                        verifyCredential(
                            jwtCredential,
                            credentialType,
                            finalizeOffersDescriptor.serviceTypes
                        ) { [weak self] result in
                            do {
                                let isVerified = try result.get()
//                                do nothing
                            } catch {
                                if let e = error as? VCLError {
                                    globalError = e
                                } else {
                                    globalError = VCLError(
                                        payload: "\(error)",
                                        errorCode: VCLErrorCode.IssuerUnexpectedPermissionFailure.rawValue
                                    )
                                }
                            }
                            self?.mainDispatcher.leave()
                        }
                    } else {
                        globalError = VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue)
                        mainDispatcher.leave()
                    }
                } else {
                    globalError = VCLError(errorCode: VCLErrorCode.CredentialTypeNotRegistered.rawValue)
                    mainDispatcher.leave()
                }
            }
            mainDispatcher.notify(queue: DispatchQueue.global(), execute: {
                if let e = globalError {
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
        if (serviceTypes.contains(serviceType: VCLServiceType.IdentityIssuer)) {
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
        if (credentialType.issuerCategory == VCLServiceType.IdentityIssuer.rawValue) {
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
            if let credentialSubject = Utils.getCredentialSubject(jwtCredential) {
                if let credentialSubjectContexts = (credentialSubject[CredentialIssuerVerifierImpl.CodingKeys.KeyContext] as? [String]) {
                    resolveCredentialSubjectContexts(credentialSubjectContexts) { [weak self] credentialSubjectContextsResult in
                        if let _self = self {
                            do {
                                let completeContexts = try credentialSubjectContextsResult.get()
                                _self.onResolveCredentialSubjectContexts(
                                    credentialSubject,
                                    jwtCredential,
                                    completeContexts,
                                    _self,
                                    completionBlock
                                )
                            }
                            catch {
                                _self.onError(
                                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
                                    completionBlock
                                )
                            }
                        } else {
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
                        VCLLog.e("Invalid format of credentialSubjectContext: \(credentialSubjectContext)")
                    }
                } catch {
                    VCLLog.e("Error fetching \(credentialSubjectContext)")
                }
                self?.resolveConetxDispatcher.leave()
            }
        }
        
        resolveConetxDispatcher.notify(queue: DispatchQueue.global(), execute: {
            if(completeContexts.isEmpty) {
                self.onError(
                    VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue),
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
        _ _self: CredentialIssuerVerifierImpl,
        _ completionBlock: @escaping (VCLResult<Bool>) -> Void
    ) {
        if let credentialSubjectType = (credentialSubject[CodingKeys.KeyType] as? String) {
            
            var globalError: VCLError? = nil
            self.completeConetxBackgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask (withName: "Finish completeConetxBackgroundTaskIdentifier") {
                UIApplication.shared.endBackgroundTask(self.completeConetxBackgroundTaskIdentifier!)
                self.completeConetxBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            }
            
            completeContexts.forEach { completeContext in
                
                completeConetxDispatcher.enter()
                
                if let context = (((completeContext[CodingKeys.KeyContext] as? [String: Any])?[credentialSubjectType] as? [String: Any])?[CodingKeys.KeyContext] as? [String: Any]) {
                    if let K = _self.findKeyForPrimaryOrganizationValue(context) {
                        if let did = ((credentialSubject[K] as? [String: Any])?[CodingKeys.KeyIdentifier] as? String) {
                            if (jwtCredential.iss == did) {
//                                do nothing
                                completeConetxDispatcher.leave()
                            } else {
                                globalError = VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission.rawValue)
                                completeConetxDispatcher.leave()
                            }
                        } else {
                            globalError = VCLError(errorCode: VCLErrorCode.IssuerRequiresNotaryPermission.rawValue)
                            completeConetxDispatcher.leave()
                        }
                    } else {
                        globalError = VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectType.rawValue)
                        completeConetxDispatcher.leave()
                    }
                } else {
                    globalError = VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectContext.rawValue)
                    completeConetxDispatcher.leave()
                }
            }
            completeConetxDispatcher.notify(queue: DispatchQueue.global(), execute: {
                if let e = globalError {
                    completionBlock(.failure(e))
                } else {
                    completionBlock(.success(true))
                }
            })
            
            UIApplication.shared.endBackgroundTask(mainBackgroundTaskIdentifier)
            mainBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
            
        } else {
            _self.onError(
                VCLError(errorCode: VCLErrorCode.InvalidCredentialSubjectType.rawValue),
                completionBlock
            )
        }
    }
    
    func findKeyForPrimaryOrganizationValue(_ context: [String: Any]) -> String? {
        var retVal: String? = nil
        context.forEach { (key, value) in
            if ((value as? [String: Any])?[CodingKeys.KeyId] as? String == CodingKeys.ValPrimaryOrganization) {
                retVal = key
            }
        }
        return retVal
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
    }
}
