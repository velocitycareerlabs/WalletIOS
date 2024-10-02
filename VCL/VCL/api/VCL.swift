//
//  VCL.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public protocol VCL: Sendable {
    
    func initialize(
        initializationDescriptor: VCLInitializationDescriptor,
        successHandler: @escaping @Sendable () -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    var countries: VCLCountries? { get }
    var credentialTypes: VCLCredentialTypes? { get }
    var credentialTypeSchemas: VCLCredentialTypeSchemas? { get }
    
    func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        successHandler: @escaping @Sendable (VCLPresentationRequest) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        successHandler: @escaping @Sendable (VCLSubmissionResult) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func getExchangeProgress(
        exchangeDescriptor: VCLExchangeDescriptor,
        successHandler: @escaping @Sendable (VCLExchange) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func searchForOrganizations(
        organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
        successHandler: @escaping @Sendable (VCLOrganizations) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        successHandler: @escaping @Sendable (VCLCredentialManifest) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        successHandler: @escaping @Sendable (VCLOffers) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func checkForOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping @Sendable (VCLOffers) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        sessionToken: VCLToken,
        successHandler: @escaping @Sendable (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func getCredentialTypesUIFormSchema(
        credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor,
        successHandler: @escaping @Sendable (VCLCredentialTypesUIFormSchema) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func getVerifiedProfile(
        verifiedProfileDescriptor: VCLVerifiedProfileDescriptor,
        successHandler: @escaping @Sendable (VCLVerifiedProfile) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func verifyJwt(
        jwt: VCLJwt,
        publicJwk: VCLPublicJwk,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping @Sendable (Bool) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func generateSignedJwt(
        jwtDescriptor: VCLJwtDescriptor,
        didJwk: VCLDidJwk,
        remoteCryptoServicesToken: VCLToken?,
        successHandler: @escaping @Sendable (VCLJwt) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
    
    func generateDidJwk(
        didJwkDescriptor: VCLDidJwkDescriptor,
        successHandler: @escaping @Sendable (VCLDidJwk) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    )
}

extension VCL {
    public func getPresentationRequest(
        presentationRequestDescriptor: VCLPresentationRequestDescriptor,
        successHandler: @escaping @Sendable (VCLPresentationRequest) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    ) {
        getPresentationRequest(
            presentationRequestDescriptor: presentationRequestDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        successHandler: @escaping @Sendable (VCLSubmissionResult) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    ) {
        submitPresentation(
            presentationSubmission: presentationSubmission,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func getCredentialManifest(
        credentialManifestDescriptor: VCLCredentialManifestDescriptor,
        successHandler: @escaping @Sendable (VCLCredentialManifest) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    ) {
        getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
    
    public func generateOffers(
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        successHandler: @escaping @Sendable (VCLOffers) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
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
        successHandler: @escaping @Sendable (VCLJwtVerifiableCredentials) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
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
        successHandler: @escaping @Sendable (Bool) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
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
        successHandler: @escaping @Sendable (VCLJwt) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
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
        successHandler: @escaping @Sendable (VCLDidJwk) -> Void,
        errorHandler: @escaping @Sendable (VCLError) -> Void
    ) {
        generateDidJwk(
            didJwkDescriptor: didJwkDescriptor,
            successHandler: successHandler,
            errorHandler: errorHandler
        )
    }
}
