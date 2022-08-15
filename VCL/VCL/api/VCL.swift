//
//  VCL.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//

public protocol VCL {
    
    func initialize(
        environment: VCLEnvironment,
        successHandler: @escaping () -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    var countries: VCLCountries? { get }
    var credentialTypes: VCLCredentialTypes? { get }
    var credentialTypeSchemas: VCLCredentialTypeSchemas? { get }
    
    func getPresentationRequest(
        deepLink: VCLDeepLink,
        successHandler: @escaping (VCLPresentationRequest) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func submitPresentation(
        presentationSubmission: VCLPresentationSubmission,
        successHandler: @escaping (VCLPresentationSubmissionResult) -> Void,
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
        token: VCLToken,
        successHandler: @escaping (VCLOffers) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func finalizeOffers(
        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
        token: VCLToken,
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
        jwt: VCLJWT,
        publicKey: VCLPublicKey,
        successHandler: @escaping (Bool) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
    
    func generateSignedJwt(
        payload: [String: Any],
        iss: String,
        successHandler: @escaping (VCLJWT) -> Void,
        errorHandler: @escaping (VCLError) -> Void
    )
}

extension VCL {
    func printVersion() {
        VCLLog.d("Version: \(GlobalConfig.Version)")
        VCLLog.d("Build: \(GlobalConfig.Build)")
    }
}
