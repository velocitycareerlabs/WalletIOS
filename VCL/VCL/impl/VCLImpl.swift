//
//  VCLImpl.swift
//  VCL
//
//  Created by Michael Avoyan on 20/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public class VCLImpl: VCL {
    
    private static let ModelsToInitializeAmount = 3
    
    private var initializationDescriptor: VCLInitializationDescriptor!
    
    private var credentialTypesModel: CredentialTypesModel!
    private var credentialTypeSchemasModel: CredentialTypeSchemasModel!
    private var countriesModel: CountriesModel!
    
    private var presentationRequestUseCase: PresentationRequestUseCase!
    private var presentationSubmissionUseCase: PresentationSubmissionUseCase!
    private var exchangeProgressUseCase: ExchangeProgressUseCase!
    private var organizationsUseCase: OrganizationsUseCase!
    private var credentialManifestUseCase: CredentialManifestUseCase!
    private var identificationSubmissionUseCase: IdentificationSubmissionUseCase!
    private var generateOffersUseCase: GenerateOffersUseCase!
    private var finalizeOffersUseCase: FinalizeOffersUseCase!
    private var credentialTypesUIFormSchemaUseCase: CredentialTypesUIFormSchemaUseCase!
    private var verifiedProfileUseCase: VerifiedProfileUseCase!
    private var jwtServiceUseCase: JwtServiceUseCase!
    private var keyServiceUseCase: KeyServiceUseCase!
    
    private var initializationWatcher = InitializationWatcher(initAmount: VCLImpl.ModelsToInitializeAmount)
    private var profileServiceTypeVerifier: ProfileServiceTypeVerifier?
    
    public func initialize(
        initializationDescriptor: VCLInitializationDescriptor,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        
        self.initializationDescriptor = initializationDescriptor
        
        initGlobalConfigurations()
        
        printVersion()
        
        self.initializationWatcher = InitializationWatcher(initAmount: VCLImpl.ModelsToInitializeAmount)
        
        cacheRemoteData(
            cacheSequence: initializationDescriptor.cacheSequence,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    private func initializeUseCases() throws {
        presentationRequestUseCase =
        try VclBlocksProvider.providePresentationRequestUseCase(
            initializationDescriptor.cryptoServicesDescriptor
        )
        presentationSubmissionUseCase = try VclBlocksProvider.providePresentationSubmissionUseCase(
            initializationDescriptor.cryptoServicesDescriptor
        )
        exchangeProgressUseCase = VclBlocksProvider.provideExchangeProgressUseCase()
        organizationsUseCase = VclBlocksProvider.provideOrganizationsUseCase()
        credentialManifestUseCase =
        try VclBlocksProvider.provideCredentialManifestUseCase(
            initializationDescriptor.cryptoServicesDescriptor
        )
        identificationSubmissionUseCase = try VclBlocksProvider.provideIdentificationSubmissionUseCase(
            initializationDescriptor.cryptoServicesDescriptor
        )
        generateOffersUseCase = VclBlocksProvider.provideGenerateOffersUseCase()
        finalizeOffersUseCase =
        try VclBlocksProvider.provideFinalizeOffersUseCase(
            initializationDescriptor.cryptoServicesDescriptor,
            credentialTypesModel,
            initializationDescriptor.isDirectIssuerCheckOn
        )
        credentialTypesUIFormSchemaUseCase =
        VclBlocksProvider.provideCredentialTypesUIFormSchemaUseCase()
        verifiedProfileUseCase = VclBlocksProvider.provideVerifiedProfileUseCase()
        jwtServiceUseCase = try VclBlocksProvider.provideJwtServiceUseCase(initializationDescriptor.cryptoServicesDescriptor)
        keyServiceUseCase = try VclBlocksProvider.provideKeyServiceUseCase(initializationDescriptor.cryptoServicesDescriptor)
    }
    
    private func completionHandler(
        _ successHandler: @escaping () -> Void,
        _ errorHandler: @escaping (VCLError) -> Void
    ) {
        if let error = self.initializationWatcher.firstError() {
            errorHandler(error)
        } else {
            do {
                try self.initializeUseCases()
                
                self.profileServiceTypeVerifier = ProfileServiceTypeVerifier(verifiedProfileUseCase: self.verifiedProfileUseCase)
                
                successHandler()
            } catch where error is VCLError {
                errorHandler(error as! VCLError)
            } catch {
                errorHandler(VCLError(error: error))
            }
        }
    }
    
    private func cacheRemoteData(
        cacheSequence: Int,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        credentialTypesModel = VclBlocksProvider.provideCredentialTypesModel()
        
        countriesModel = VclBlocksProvider.provideCountriesModel()
        
        countriesModel.initialize(cacheSequence: cacheSequence) { [weak self] result in
            do {
                _ = try result.get()
                if self?.initializationWatcher.onInitializedModel(error: nil) == true {
                    self?.completionHandler(successHandler, errorHandler)
                }
            } catch {
                if self?.initializationWatcher.onInitializedModel(error: error as? VCLError) == true {
                    self?.completionHandler(successHandler, errorHandler)
                }
            }
        }
        credentialTypesModel.initialize(cacheSequence: cacheSequence) { [weak self] result in
            do {
                _ = try result.get()
                if self?.initializationWatcher.onInitializedModel(error: nil) == true {
                    self?.completionHandler(successHandler, errorHandler)
                }
                else {
                    if let credentialTypes = self?.credentialTypesModel.data {
                        self?.credentialTypeSchemasModel = VclBlocksProvider.provideCredentialTypeSchemasModel(credenctiialTypes: credentialTypes)
                        self?.credentialTypeSchemasModel?.initialize(cacheSequence: cacheSequence) { result in
                            do {
                                _ = try result.get()
                                if self?.initializationWatcher.onInitializedModel(error: nil) == true {
                                    self?.completionHandler(successHandler, errorHandler)
                                }
                            } catch {
                                if self?.initializationWatcher.onInitializedModel(error: error as? VCLError) == true {
                                    self?.completionHandler(successHandler, errorHandler)
                                }
                            }
                        }
                    } else {
                        errorHandler(VCLError(message: "Failed to get credential type schemas"))
                    }
                }
            } catch {
                if self?.initializationWatcher.onInitializedModel(error: error as? VCLError, enforceFailure: true) == true {
                    self?.completionHandler(successHandler, errorHandler)
                }
            }
        }
    }
    
    private func initGlobalConfigurations() {
        GlobalConfig.CurrentEnvironment = initializationDescriptor.environment
        GlobalConfig.XVnfProtocolVersion = initializationDescriptor.xVnfProtocolVersion
        GlobalConfig.SignatureAlgorithm = initializationDescriptor.cryptoServicesDescriptor.signatureAlgorithm
        GlobalConfig.KeycahinAccessGroupIdentifier = initializationDescriptor.keycahinAccessGroupIdentifier
        GlobalConfig.IsDebugOn = initializationDescriptor.isDebugOn
    }
    
    public var countries: VCLCountries? { get { return countriesModel.data } }
    
    public var credentialTypes: VCLCredentialTypes? { get { return credentialTypesModel.data } }
    
    public var credentialTypeSchemas: VCLCredentialTypeSchemas? { get { return credentialTypeSchemasModel?.data } }
    
    public func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        if let did = presentationRequestDescriptor.did {
            profileServiceTypeVerifier?.verifyServiceTypeOfVerifiedProfile(
                verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: did),
                expectedServiceTypes: VCLServiceTypes(serviceType: VCLServiceType.Inspector),
                successHandler: { [weak self] _ in
                    self?.presentationRequestUseCase.getPresentationRequest(
                        presentationRequestDescriptor: presentationRequestDescriptor
                    ) { presentationRequestResult in
                        
                        do {
                            successHandler(try presentationRequestResult.get())
                        } catch {
                            self?.logError(message: "getPresentationRequest", error: error)
                            errorHandler(VCLError(error: error))
                        }
                    }
                },
                errorHandler: { [weak self] in
                    self?.logError(message: "profile verification failed", error: $0)
                    errorHandler($0)
                }
            )
        } else {
            let error = VCLError(message: "did was not found in ֿ\(presentationRequestDescriptor)")
            logError(message: "getPresentationRequest::verifiedProfile", error: error)
            errorHandler(error)
        }
    }
    
    public func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        successHandler: @escaping (VCLSubmissionResult) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        presentationSubmissionUseCase.submit(
            submission: presentationSubmission
        ) {
            [weak self] presentationSubmissionResult in
            do {
                successHandler(try presentationSubmissionResult.get())
            } catch {
                self?.logError(message: "submit presentation", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func getExchangeProgress(
        exchangeDescriptor: VCLExchangeDescriptor,
        successHandler: @escaping (VCLExchange) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        exchangeProgressUseCase.getExchangeProgress(
            exchangeDescriptor: exchangeDescriptor
        ) {
            [weak self] exchangeProgressResult in
            do {
                successHandler(try exchangeProgressResult.get())
            } catch {
                self?.logError(message: "getExchangeProgress", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
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
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        successHandler: @escaping (VCLCredentialManifest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        VCLLog.d("credentialManifestDescriptor: \(credentialManifestDescriptor.toPropsString())")
        if let did = credentialManifestDescriptor.did {
            profileServiceTypeVerifier?.verifyServiceTypeOfVerifiedProfile(
                verifiedProfileDescriptor: VCLVerifiedProfileDescriptor(did: did),
                expectedServiceTypes: VCLServiceTypes(issuingType: credentialManifestDescriptor.issuingType),
                successHandler: { [weak self] verifiedProfile in
                    self?.credentialManifestUseCase.getCredentialManifest(
                        credentialManifestDescriptor: credentialManifestDescriptor,
                        verifiedProfile: verifiedProfile
                    ) { [weak self] credentialManifestResult in
                        do {
                            successHandler(try credentialManifestResult.get())
                        }
                        catch {
                            self?.logError(message: "getCredentialManifest", error: error)
                            errorHandler(VCLError(error: error))
                        }
                    }
                },
                errorHandler: { [weak self] in
                    self?.logError(message: "profile verification failed", error: $0)
                    errorHandler($0)
                }
            )
        } else {
            let error = VCLError(message: "did was not found in \(credentialManifestDescriptor)")
            logError(message: "getCredentialManifest::verifiedProfile", error: error)
            errorHandler(error)
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
        identificationSubmissionUseCase.submit(
            submission: identificationSubmission
        ) {
            [weak self] identificationSubmissionResult in
            do {
                let identificationSubmission = try identificationSubmissionResult.get()
                self?.generateOffersUseCase.generateOffers(
                    generateOffersDescriptor: generateOffersDescriptor,
                    sessionToken: identificationSubmission.sessionToken
                ) {
                    vnOffersResult in
                    do {
                        successHandler(try vnOffersResult.get())
                    } catch {
                        self?.logError(message: "submit identification", error: error)
                        errorHandler(error as? VCLError ?? VCLError(error: error))
                    }
                }
                
            } catch {
                self?.logError(message: "submit identification", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func checkForOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        invokeGenerateOffersUseCase(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: sessionToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    private func invokeGenerateOffersUseCase(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateOffersUseCase.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            sessionToken: sessionToken
        ) {
            [weak self] offersResult in
            do {
                successHandler(try offersResult.get())
            } catch {
                self?.logError(message: "generateOffers", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        finalizeOffersUseCase.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptor,
            sessionToken: sessionToken
        ) {
            [weak self] jwtVerifiableCredentials in
            do {
                successHandler(try jwtVerifiableCredentials.get())
            } catch {
                self?.logError(message: "finalizeOffers", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
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
                    errorHandler(error as? VCLError ?? VCLError(error: error))
                }
            }
        } else {
            let error = VCLError(message: "No countries for getCredentialTypesUIFormSchema")
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
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (Bool) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        jwtServiceUseCase.verifyJwt(
            jwt: jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken
        ) {
            [weak self] isVerifiedResult in
            do {
                successHandler(try isVerifiedResult.get())
            } catch {
                self?.logError(message: "verifyJwt", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLJwt) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        jwtServiceUseCase.generateSignedJwt(
            jwtDescriptor: jwtDescriptor, 
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken
        ) {
            [weak self] jwtResult in
            do {
                successHandler(try jwtResult.get())
            } catch {
                self?.logError(message: "generateSignedJwt", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
    
    public func generateDidJwk(
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLDidJwk) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        keyServiceUseCase.generateDidJwk(
            remoteCryptoServicesToken: remoteCryptoServicesToken
        ) {
            [weak self] didJwkResult in
            do {
                successHandler(try didJwkResult.get())
            } catch {
                self?.logError(message: "generateDidJwk", error: error)
                errorHandler(error as? VCLError ?? VCLError(error: error))
            }
        }
    }
}

extension VCLImpl {
    func logError(message: String = "", error: Error) {
        VCLLog.e("\(message): \(error)")
    }
    
    func printVersion() {
        VCLLog.d("Version: \(GlobalConfig.Version)")
        VCLLog.d("Build: \(GlobalConfig.Build)")
    }
}
