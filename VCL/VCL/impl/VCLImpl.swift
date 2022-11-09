//
//  VCLImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 20/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

public class VCLImpl: VCL {
    
    private static let ModelsToInitilizeAmount = 3
    
    private let countriesModel = VclBlocksProvider.provideCountriesModel()
    private let credentialTypesModel =  VclBlocksProvider.provideCredentialTypesModel()
    private var credentialTypeSchemasModel: CredentialTypeSchemasModel?
    
    private let presentationRequestUseCase = VclBlocksProvider.providePresentationRequestUseCase()
    private let presentationSubmissionUseCase = VclBlocksProvider.providePresentationSubmissionUseCase()
    private let exchangeProgressUseCase = VclBlocksProvider.provideExchangeProgressUseCase()
    private let organizationsUseCase = VclBlocksProvider.provideOrganizationsUseCase()
    private let credentialManifestUseCase = VclBlocksProvider.provideCredentialManifestUseCase()
    private let identificationUseCase = VclBlocksProvider.provideIdentificationUseCase()
    private let generateOffersUseCase = VclBlocksProvider.provideGenerateOffersUseCase()
    private let finalizeOffersUseCase = VclBlocksProvider.provideFinalizeOffersUseCase()
    private let credentialTypesUIFormSchemaUseCase = VclBlocksProvider.provideCredentialTypesUIFormSchemaUseCase()
    private let verifiedProfileUseCase = VclBlocksProvider.provideVerifiedProfileUseCase()
    private let jwtServiceUseCase = VclBlocksProvider.provideJwtServiceUseCase()
    
    private var initializationWatcher = InitializationWatcher(initAmount: VCLImpl.ModelsToInitilizeAmount)
    
    public func initialize(
        initializationDescriptor: VCLInitializationDescriptor,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        initializationWatcher = InitializationWatcher(initAmount: VCLImpl.ModelsToInitilizeAmount)
        
        initGlobalConfigurations(initializationDescriptor.environment)
        
        printVersion()
        
        let completionHandler = {
            if let error = self.initializationWatcher.firstError() {
                errorHandler(error)
            }
            else {
                successHandler()
            }
        }
        countriesModel.initialize(cacheSequence: initializationDescriptor.cacheSequence) { [weak self] result in
            do {
                _ = try result.get()
                if self?.initializationWatcher.onInitializedModel(error: nil) == true {
                    completionHandler()
                }
            } catch {
                if self?.initializationWatcher.onInitializedModel(error: error as? VCLError) == true {
                    completionHandler()
                }
            }
        }
        credentialTypesModel.initialize(cacheSequence: initializationDescriptor.cacheSequence) { [weak self] result in
            do {
                _ = try result.get()
                if self?.initializationWatcher.onInitializedModel(error: nil) == true {
                    completionHandler()
                }
                else {
                    if let credentialTypes = self?.credentialTypesModel.data {
                        self?.credentialTypeSchemasModel = VclBlocksProvider.provideCredentialTypeSchemasModel(credenctiialTypes: credentialTypes)
                        self?.credentialTypeSchemasModel?.initialize(cacheSequence: initializationDescriptor.cacheSequence) { result in
                            do {
                                _ = try result.get()
                                if self?.initializationWatcher.onInitializedModel(error: nil) == true {
                                    completionHandler()
                                }
                            } catch {
                                if self?.initializationWatcher.onInitializedModel(error: error as? VCLError) == true {
                                    completionHandler()
                                }
                            }
                        }
                    } else {
                        errorHandler(VCLError(description: "Failed to get credential type schemas"))
                    }
                }
            } catch {
                if self?.initializationWatcher.onInitializedModel(error: error as? VCLError, enforceFailure: true) == true {
                    completionHandler()
                }
            }
        }
    }
    
    private func initGlobalConfigurations(_ environment: VCLEnvironment) {
        GlobalConfig.CurrentEnvironment = environment
    }
    
    public var countries: VCLCountries? { get { return countriesModel.data } }
        
    public var credentialTypes: VCLCredentialTypes? { get { return credentialTypesModel.data } }
    
    public var credentialTypeSchemas: VCLCredentialTypeSchemas? { get { return credentialTypeSchemasModel?.data } }
    
    public func getPresentationRequest(
        deepLink: VCLDeepLink,
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        presentationRequestUseCase.getPresentationRequest(deepLink: deepLink) {
            [weak self] presentationRequestResult in
            do {
                successHandler(try presentationRequestResult.get())
            } catch {
                self?.logError(message: "getPresentationRequest", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        successHandler: @escaping (VCLPresentationSubmissionResult) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        presentationSubmissionUseCase.submit(submission: presentationSubmission) {
            [weak self] presentationSubmissionResult in
            do {
                successHandler(try presentationSubmissionResult.get())
            } catch {
                self?.logError(message: "submit presentation", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func getExchangeProgress(
        exchangeDescriptor: VCLExchangeDescriptor,
        successHandler: @escaping (VCLExchange) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        exchangeProgressUseCase.getExchangeProgress(exchangeDescriptor: exchangeDescriptor) {
            [weak self] exchangeProgressResult in
            do {
                successHandler(try exchangeProgressResult.get())
            } catch {
                self?.logError(message: "getExchangeProgress", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func searchForOrganizations(
        organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
        successHandler: @escaping (VCLOrganizations) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        organizationsUseCase.searchForOrganizations(organizationsSearchDescriptor: organizationsSearchDescriptor) {
            [weak self] organizationsResult in
            do {
                successHandler(try organizationsResult.get())
            } catch {
                self?.logError(message: "searchForOrganizations", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        successHandler: @escaping (VCLCredentialManifest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        credentialManifestUseCase.getCredentialManifest(credentialManifestDescriptor: credentialManifestDescriptor) {
            [weak self] credentialManifest in
            do {
                successHandler(try credentialManifest.get())
            } catch {
                self?.logError(message: "getCredentialManifest", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        let identificationSubmission = VCLIdentificationSubmission(
            credentialManifest: generateOffersDescriptor.credentialManifest,
            verifiableCredentials: generateOffersDescriptor.identificationVerifiableCredentials
        )
        identificationUseCase.submit(submission: identificationSubmission) {
            [weak self] identificationSubmissionResult in
            do {
                let identificationSubmission = try identificationSubmissionResult.get()
                self?.generateOffersUseCase.generateOffers(
                    token: identificationSubmission.token,
                    generateOffersDescriptor: generateOffersDescriptor) {
                    vnOffersResult in
                    do {
                        successHandler(try vnOffersResult.get())
                    } catch {
                        self?.logError(message: "submit identification", error: error)
                        errorHandler(VCLError(error: error))
                    }
                }
                
            } catch {
                self?.logError(message: "submit identification", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func checkForOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        token: VCLToken,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        invokeGenerateOffersUseCase(
            generateOffersDescriptor: generateOffersDescriptor,
            token: token,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    private func invokeGenerateOffersUseCase(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        token: VCLToken,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateOffersUseCase.generateOffers(
            token: token,
            generateOffersDescriptor: generateOffersDescriptor
        ) {
            [weak self] vnOffersResult in
            do {
                successHandler(try vnOffersResult.get())
            } catch {
                self?.logError(message: "generateOffers", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        token: VCLToken,
        successHandler: @escaping (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        finalizeOffersUseCase.finalizeOffers(
            token: token,
            finalizeOffersDescriptor: finalizeOffersDescriptor) {
                [weak self] jwtVerifiableCredentials in
                do {
                    successHandler(try jwtVerifiableCredentials.get())
                } catch {
                    self?.logError(message: "finalizeOffers", error: error)
                    errorHandler(VCLError(error: error))
                }
            }
    }
    
    public func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        successHandler: @escaping (VCLCredentialTypesUIFormSchema) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        if let countries = countriesModel.data {
            credentialTypesUIFormSchemaUseCase.getCredentialTypesUIFormSchema(
                credentialTypesUIFormSchemaDescriptor: credentialTypesUIFormSchemaDescriptor,
                countries: countries
            ) { [weak self] credentialTypesUIFormSchemaResult in
                do {
                    successHandler(try credentialTypesUIFormSchemaResult.get())
                } catch {
                    self?.logError(message: "getCredentialTypesUIFormSchema", error: error)
                    errorHandler(VCLError(error: error))
                }
            }
        } else {
            let error = VCLError(description: "No countries for getCredentialTypesUIFormSchema")
            self.logError(message: "getCredentialTypesUIFormSchema", error: error)
            errorHandler(error)
        }
    }
    
    public func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        successHandler: @escaping (VCLVerifiedProfile) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        verifiedProfileUseCase.getVerifiedProfile(verifiedProfileDescriptor: verifiedProfileDescriptor) {
            [weak self] verifiedProfileResult in
            do {
                successHandler(try verifiedProfileResult.get())
            } catch {
                self?.logError(message: "getVerifiedProfile", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func verifyJwt(
        jwt: VCLJWT,
        publicKey: VCLPublicKey,
        successHandler: @escaping (Bool) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        jwtServiceUseCase.verifyJwt(jwt: jwt, publicKey: publicKey) {
            [weak self] isVerifiedResult in
            do {
                successHandler(try isVerifiedResult.get())
            } catch {
                self?.logError(message: "verifyJwt", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    public func generateSignedJwt(
        payload: [String: Any],
        iss: String,
        successHandler: @escaping (VCLJWT) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        jwtServiceUseCase.generateSignedJwt(payload: payload, iss: iss) {
            [weak self] jwtResult in
            do {
                successHandler(try jwtResult.get())
            } catch {
                self?.logError(message: "generateSignedJwt", error: error)
                errorHandler(VCLError(error: error))
            }
        }
    }
}

extension VCLImpl {
    func logError(message: String = "", error: Error) {
        VCLLog.e("\(message): \(error)")
    }
}
