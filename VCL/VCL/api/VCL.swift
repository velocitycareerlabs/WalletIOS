//
//  VCL.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public protocol VCL {
    
    func initialize(
        initializationDescriptor: VCLInitializationDescriptor,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    var countries: VCLCountries? { get }
    var credentialTypes: VCLCredentialTypes? { get }
    var credentialTypeSchemas: VCLCredentialTypeSchemas? { get }
    
    func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        didJwk: VCLDidJwk?,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLSubmissionResult) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func getExchangeProgress(
        exchangeDescriptor: VCLExchangeDescriptor,
        successHandler: @escaping (VCLExchange) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func searchForOrganizations(
        organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
        successHandler: @escaping (VCLOrganizations) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLCredentialManifest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        didJwk: VCLDidJwk?,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func checkForOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        didJwk: VCLDidJwk?,
        sessionToken: VCLToken,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) 
    
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        successHandler: @escaping (VCLCredentialTypesUIFormSchema) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        successHandler: @escaping (VCLVerifiedProfile) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (Bool) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLJwt) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func generateDidJwk(
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLDidJwk) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
}

extension VCL {
    public func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        getPresentationRequest(
            presentationRequestDescriptor: presentationRequestDescriptor,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        didJwk: VCLDidJwk? = nil,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLSubmissionResult) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        submitPresentation(
            presentationSubmission: presentationSubmission,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLCredentialManifest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptor,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        didJwk: VCLDidJwk? = nil,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        didJwk: VCLDidJwk? = nil,
        sessionToken: VCLToken,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptor,
            didJwk: didJwk,
            sessionToken: sessionToken,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler:successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (Bool) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        verifyJwt(
            jwt: jwt,
            publicJwk: publicJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLJwt) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateSignedJwt(
            jwtDescriptor: jwtDescriptor,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func generateDidJwk(
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLDidJwk) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateDidJwk(
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
}
