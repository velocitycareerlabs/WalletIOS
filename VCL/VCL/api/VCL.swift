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
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
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
        successHandler: @escaping (VCLCredentialManifest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
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
        sessionToken: VCLToken,
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
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping (VCLJwt) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        successHandler: @escaping (VCLDidJwk) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
}

extension VCL {
    public func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        getPresentationRequest(
            presentationRequestDescriptor: presentationRequestDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        successHandler: @escaping (VCLSubmissionResult) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        submitPresentation(
            presentationSubmission: presentationSubmission,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        successHandler: @escaping (VCLCredentialManifest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptor,
            sessionToken: sessionToken,
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
        didJwk: VCLDidJwk,
        jwtDescriptor: VCLJwtDescriptor,
        remoteCryptoServicesToken: VCLToken? = nil,
        successHandler: @escaping (VCLJwt) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateSignedJwt(
            jwtDescriptor: jwtDescriptor,
            didJwk: didJwk,
            remoteCryptoServicesToken: remoteCryptoServicesToken,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor = VCLDidJwkDescriptor(),
        successHandler: @escaping (VCLDidJwk) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    ) {
        generateDidJwk(
            didJwkDescriptor: didJwkDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
}
