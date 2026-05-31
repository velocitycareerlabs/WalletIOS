//
//  ErrorTaxonomy.swift
//  VCL
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

enum ErrorTaxonomy {
    static let phaseLinkValidation = "link_validation"
    static let phaseClientRequestFetch = "client_request_fetch"
    static let phaseDidResolution = "did_resolution"
    static let phaseRegistrationCheck = "registration_check"
    static let phaseRequestValidation = "request_validation"
    static let phaseRequestAuthorization = "request_authorization"
    
    static let requestKindIssuing = "issuing_request"
    static let requestKindPresentation = "presentation_request"
    
    static func invalidLink(
        message: String?,
        sourceErrorCode: String? = nil,
        requestDid: String? = nil,
        requestUri: String? = nil,
        requestKind: String? = nil,
        cause: Error? = nil
    ) -> VCLError {
        VCLError(
            errorCode: VCLErrorCode.InvalidLink.rawValue,
            message: message,
            sourceErrorCode: sourceErrorCode,
            validationPhase: phaseLinkValidation,
            requestDid: requestDid,
            requestUri: requestUri,
            requestKind: requestKind,
            cause: cause
        )
    }
    
    static func classifyClientRequestFetch(
        _ error: VCLError,
        requestUri: String?,
        requestKind: String
    ) -> VCLError {
        if error.isTaxonomyError {
            return error.withMissingTaxonomyContext(
                requestUri: requestUri,
                requestKind: requestKind,
                validationPhase: phaseClientRequestFetch
            )
        }
        if error.isConnectivityFailure {
            return error.withTaxonomy(
                .ConnectivityFailure,
                validationPhase: phaseClientRequestFetch,
                requestUri: requestUri,
                requestKind: requestKind
            )
        }
        if error.statusCode == 401 || error.statusCode == 403 {
            return error.withTaxonomy(
                .ClientRequestUnauthorized,
                validationPhase: phaseClientRequestFetch,
                requestUri: requestUri,
                requestKind: requestKind
            )
        }
        return error.withTaxonomy(
            .ClientRequestRejected,
            validationPhase: phaseClientRequestFetch,
            requestUri: requestUri,
            requestKind: requestKind
        )
    }
    
    static func classifyDidResolution(_ error: VCLError, requestKind: String, requestDid: String?) -> VCLError {
        if error.isTaxonomyError {
            return error.withMissingTaxonomyContext(
                requestDid: requestDid,
                requestKind: requestKind,
                validationPhase: phaseDidResolution
            )
        }
        if error.isConnectivityFailure {
            return error.withTaxonomy(
                .ConnectivityFailure,
                validationPhase: phaseDidResolution,
                requestDid: requestDid,
                requestKind: requestKind
            )
        }
        return error.withTaxonomy(
            requestKind.didUnresolvableCode,
            validationPhase: phaseDidResolution,
            requestDid: requestDid,
            requestKind: requestKind
        )
    }
    
    static func classifyRegistration(_ error: VCLError, requestKind: String, requestDid: String?) -> VCLError {
        if error.isTaxonomyError {
            return error.withMissingTaxonomyContext(
                requestDid: requestDid,
                requestKind: requestKind,
                validationPhase: phaseRegistrationCheck
            )
        }
        if error.isConnectivityFailure {
            return error.withTaxonomy(
                .ConnectivityFailure,
                validationPhase: phaseRegistrationCheck,
                requestDid: requestDid,
                requestKind: requestKind
            )
        }
        if error.statusCode != 404 {
            return error.withTaxonomy(
                .RegistrationCheckInconclusive,
                validationPhase: phaseRegistrationCheck,
                requestDid: requestDid,
                requestKind: requestKind
            )
        }
        return error.withTaxonomy(
            requestKind.notRegisteredCode,
            validationPhase: phaseRegistrationCheck,
            requestDid: requestDid,
            requestKind: requestKind
        )
    }
    
    static func classifyServiceAuthorization(_ error: VCLError, requestKind: String, requestDid: String?) -> VCLError {
        if error.isTaxonomyError {
            return error.withMissingTaxonomyContext(
                requestDid: requestDid,
                requestKind: requestKind,
                validationPhase: phaseRequestAuthorization
            )
        }
        return error.withTaxonomy(
            requestKind.requestUnauthorizedCode,
            validationPhase: phaseRequestAuthorization,
            requestDid: requestDid,
            requestKind: requestKind
        )
    }
    
    static func classifyRequestValidation(_ error: VCLError, requestKind: String, requestDid: String?) -> VCLError {
        if error.isTaxonomyError {
            return error.withMissingTaxonomyContext(
                requestDid: requestDid,
                requestKind: requestKind,
                validationPhase: phaseRequestValidation
            )
        }
        if error.isConnectivityFailure {
            return error.withTaxonomy(
                .ConnectivityFailure,
                validationPhase: phaseRequestValidation,
                requestDid: requestDid,
                requestKind: requestKind
            )
        }
        return error.withTaxonomy(
            requestKind.requestInvalidCode,
            validationPhase: phaseRequestValidation,
            requestDid: requestDid,
            requestKind: requestKind
        )
    }
    
    static let taxonomyErrorCodes: Set<String> = [
        VCLErrorCode.InvalidLink.rawValue,
        VCLErrorCode.ConnectivityFailure.rawValue,
        VCLErrorCode.ClientRequestUnauthorized.rawValue,
        VCLErrorCode.ClientRequestRejected.rawValue,
        VCLErrorCode.IssuerDidUnresolvable.rawValue,
        VCLErrorCode.VerifierDidUnresolvable.rawValue,
        VCLErrorCode.IssuerNotRegistered.rawValue,
        VCLErrorCode.VerifierNotRegistered.rawValue,
        VCLErrorCode.RegistrationCheckInconclusive.rawValue,
        VCLErrorCode.IssuerRequestInvalid.rawValue,
        VCLErrorCode.VerifierRequestInvalid.rawValue,
        VCLErrorCode.IssuerRequestUnauthorized.rawValue,
        VCLErrorCode.VerifierRequestUnauthorized.rawValue
    ]
}

extension VCLError {
    var isConnectivityFailure: Bool {
        errorCode == VCLErrorCode.ConnectivityFailure.rawValue ||
            statusCode == VCLStatusCode.NetworkError.rawValue
    }
    
    var isTaxonomyError: Bool {
        ErrorTaxonomy.taxonomyErrorCodes.contains(errorCode)
    }
    
    func withMissingTaxonomyContext(
        requestDid: String? = nil,
        requestUri: String? = nil,
        requestKind: String? = nil,
        validationPhase: String? = nil
    ) -> VCLError {
        VCLError(
            payload: payload,
            error: error,
            errorCode: errorCode,
            requestId: requestId,
            message: message,
            statusCode: statusCode,
            sourceErrorCode: sourceErrorCode,
            validationPhase: self.validationPhase ?? validationPhase,
            requestDid: self.requestDid ?? requestDid,
            requestUri: self.requestUri ?? requestUri,
            requestKind: self.requestKind ?? requestKind,
            cause: cause
        )
    }
    
    func withTaxonomy(
        _ taxonomyCode: VCLErrorCode,
        validationPhase: String,
        requestDid: String? = nil,
        requestUri: String? = nil,
        requestKind: String? = nil
    ) -> VCLError {
        if isTaxonomyError {
            return withMissingTaxonomyContext(
                requestDid: requestDid,
                requestUri: requestUri,
                requestKind: requestKind,
                validationPhase: validationPhase
            )
        }
        return VCLError(
            payload: payload,
            error: error,
            errorCode: taxonomyCode.rawValue,
            requestId: requestId,
            message: message,
            statusCode: statusCode,
            sourceErrorCode: sourceErrorCode ?? sourceErrorCodeFor(taxonomyCode),
            validationPhase: validationPhase,
            requestDid: requestDid ?? self.requestDid,
            requestUri: requestUri ?? self.requestUri,
            requestKind: requestKind ?? self.requestKind,
            cause: cause
        )
    }
    
    private func sourceErrorCodeFor(_ taxonomyCode: VCLErrorCode) -> String? {
        if taxonomyCode == .ConnectivityFailure && errorCode == VCLErrorCode.SdkError.rawValue {
            return nil
        }
        return errorCode == taxonomyCode.rawValue ? nil : errorCode
    }
}

private extension String {
    var didUnresolvableCode: VCLErrorCode {
        isPresentationRequest ? .VerifierDidUnresolvable : .IssuerDidUnresolvable
    }
    
    var notRegisteredCode: VCLErrorCode {
        isPresentationRequest ? .VerifierNotRegistered : .IssuerNotRegistered
    }
    
    var requestInvalidCode: VCLErrorCode {
        isPresentationRequest ? .VerifierRequestInvalid : .IssuerRequestInvalid
    }
    
    var requestUnauthorizedCode: VCLErrorCode {
        isPresentationRequest ? .VerifierRequestUnauthorized : .IssuerRequestUnauthorized
    }
    
    var isPresentationRequest: Bool {
        self == ErrorTaxonomy.requestKindPresentation
    }
}
