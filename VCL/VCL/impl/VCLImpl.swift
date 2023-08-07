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
        initGlobalConfigurations(initializationDescriptor)
        
        printVersion()

        self.initializationDescriptor = initializationDescriptor

        self.initializationWatcher = InitializationWatcher(initAmount: VCLImpl.ModelsToInitializeAmount)

        cacheRemoteData(
            cacheSequence: initializationDescriptor.cacheSequence,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    private func initializeUsecases(keyServiceType: VCLKeyServiceType) {
        presentationRequestUseCase =
        VclBlocksProvider.providePresentationRequestUseCase(
            keyServiceType
        )
        presentationSubmissionUseCase = VclBlocksProvider.providePresentationSubmissionUseCase(
            keyServiceType
        )
        exchangeProgressUseCase = VclBlocksProvider.provideExchangeProgressUseCase()
        organizationsUseCase = VclBlocksProvider.provideOrganizationsUseCase()
        credentialManifestUseCase =
        VclBlocksProvider.provideCredentialManifestUseCase(
            keyServiceType
        )
        identificationSubmissionUseCase = VclBlocksProvider.provideIdentificationSubmissionUseCase(
            keyServiceType
        )
        generateOffersUseCase = VclBlocksProvider.provideGenerateOffersUseCase()
        finalizeOffersUseCase =
        VclBlocksProvider.provideFinalizeOffersUseCase(
            keyServiceType,
            credentialTypesModel
        )
        credentialTypesUIFormSchemaUseCase =
        VclBlocksProvider.provideCredentialTypesUIFormSchemaUseCase()
        verifiedProfileUseCase = VclBlocksProvider.provideVerifiedProfileUseCase()
        jwtServiceUseCase =
        VclBlocksProvider.provideJwtServiceUseCase(keyServiceType)
        keyServiceUseCase =
        VclBlocksProvider.provideKeyServiceUseCase(keyServiceType)
    }
    
    private func completionHandler(
        _ successHandler: @escaping () -> Void,
        _ errorHandler: @escaping (VCLError) -> Void
    ) {
        if let error = self.initializationWatcher.firstError() {
            errorHandler(error)
        } else {
            self.initializeUsecases(
                keyServiceType: self.initializationDescriptor.keyServiceType
            )
            self.profileServiceTypeVerifier = ProfileServiceTypeVerifier(verifiedProfileUseCase: self.verifiedProfileUseCase)
            
            successHandler()
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
    
    private func initGlobalConfigurations(
        _ initializationDescriptor: VCLInitializationDescriptor
    ) {
        GlobalConfig.CurrentEnvironment = initializationDescriptor.environment
        GlobalConfig.XVnfProtocolVersion = initializationDescriptor.xVnfProtocolVersion
        GlobalConfig.KeycahinAccessGroupIdentifier = initializationDescriptor.keycahinAccessGroupIdentifier
        GlobalConfig.IsDebug = initializationDescriptor.isDebugOn
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
        didJwk: VCLDidJwk? = nil,
        successHandler: @escaping (VCLSubmissionResult) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        presentationSubmissionUseCase.submit(
            submission: presentationSubmission,
            didJwk: didJwk
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
        didJwk: VCLDidJwk? = nil,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        let identificationSubmission = VCLIdentificationSubmission(
            credentialManifest: generateOffersDescriptor.credentialManifest,
            verifiableCredentials: generateOffersDescriptor.identificationVerifiableCredentials
        )
        identificationSubmissionUseCase.submit(
            submission: identificationSubmission,
            didJwk: didJwk
        ) {
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
        didJwk: VCLDidJwk? = nil,
        token: VCLToken,
        successHandler: @escaping (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        finalizeOffersUseCase.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptor,
            didJwk: didJwk,
            token: token
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
        jwkPublic: VCLJwkPublic,
        successHandler: @escaping (Bool) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        jwtServiceUseCase.verifyJwt(jwt: jwt, jwkPublic: jwkPublic) {
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
        successHandler: @escaping (VCLJwt) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        jwtServiceUseCase.generateSignedJwt(jwtDescriptor: jwtDescriptor) {
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
        successHandler: @escaping (VCLDidJwk) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        keyServiceUseCase.generateDidJwk(
            completionBlock: {
                [weak self] didJwkResult in
                do {
                    successHandler(try didJwkResult.get())
                } catch {
                    self?.logError(message: "generateDidJwk", error: error)
                    errorHandler(error as? VCLError ?? VCLError(error: error))
                }
            })
    }
}

extension VCLImpl {
    func logError(message: String = "", error: Error) {
        VCLLog.e("\(message): \(error)")
    }
}
