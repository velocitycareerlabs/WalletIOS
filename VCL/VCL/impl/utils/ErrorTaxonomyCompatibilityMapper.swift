//
//  ErrorTaxonomyCompatibilityMapper.swift
//  VCL
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

final class ErrorTaxonomyCompatibilityMapper {
    func map(error: VCLError, requestKind: String) -> VCLError {
        switch error.errorCode {
        case VCLErrorCode.InvalidLink.rawValue:
            return mapInvalidLink(error, requestKind: requestKind)
        case VCLErrorCode.ConnectivityFailure.rawValue:
            return legacyCopy(error, errorCode: VCLErrorCode.SdkError.rawValue)
        default:
            return error.isTaxonomyError ? mapTaxonomyError(error) : mapNetworkStatus(error)
        }
    }
    
    private func mapInvalidLink(_ error: VCLError, requestKind: String) -> VCLError {
        let endpointNullMessage = requestKind.endpointNullMessage
        switch error.sourceErrorCode {
        case VelocityDeepLinkValidator.sourceInvalidOrMissingDid:
            if error.requestUri != nil {
                return legacyCopy(error, errorCode: requestKind.mismatchErrorCode)
            }
            return legacyCopy(
                error,
                errorCode: VCLErrorCode.SdkError.rawValue,
                message: Self.legacyMissingDidMessage
            )
        case VelocityDeepLinkValidator.sourceInvalidOrMissingRequestUri,
            VelocityDeepLinkValidator.sourceInvalidOrMissingRequestEndpoint:
            return mapInvalidRequestUri(error, endpointNullMessage: endpointNullMessage)
        case VelocityDeepLinkValidator.sourceUnparseablePayload:
            return legacyCopy(
                error,
                errorCode: VCLErrorCode.SdkError.rawValue,
                message: Self.legacyMissingDidMessage
            )
        default:
            return legacyCopy(
                error,
                errorCode: VCLErrorCode.SdkError.rawValue,
                message: endpointNullMessage
            )
        }
    }
    
    private func mapInvalidRequestUri(_ error: VCLError, endpointNullMessage: String) -> VCLError {
        if let requestUri = error.requestUri {
            if requestUri.hasPrefix("ftp://") || !requestUri.contains("://") {
                return legacyCopy(
                    error,
                    errorCode: VCLErrorCode.SdkError.rawValue,
                    message: "Error Domain=NSURLErrorDomain Code=-1002"
                )
            }
        }
        return legacyCopy(
            error,
            errorCode: VCLErrorCode.SdkError.rawValue,
            message: endpointNullMessage
        )
    }
    
    private func mapTaxonomyError(_ error: VCLError) -> VCLError {
        let networkStatusError = mapNetworkStatus(error)
        let sourceErrorCode = networkStatusError.sourceErrorCode
        if sourceErrorCode == networkStatusError.errorCode ||
            sourceErrorCode == ProfileServiceTypeVerifier.sourceWrongServiceType ||
            sourceErrorCode == nil {
            return legacyCopy(networkStatusError, errorCode: VCLErrorCode.SdkError.rawValue)
        }
        return legacyCopy(networkStatusError, errorCode: sourceErrorCode!)
    }
    
    private func mapNetworkStatus(_ error: VCLError) -> VCLError {
        guard let payloadStatusCode = error.payload?.toDictionary()?[VCLError.CodingKeys.KeyStatusCode] as? Int else {
            return error
        }
        return VCLError(
            payload: error.payload,
            error: error.error,
            errorCode: error.errorCode,
            requestId: error.requestId,
            message: error.message,
            statusCode: payloadStatusCode,
            sourceErrorCode: error.sourceErrorCode,
            validationPhase: error.validationPhase,
            requestDid: error.requestDid,
            requestUri: error.requestUri,
            requestKind: error.requestKind,
            cause: error.cause
        )
    }
    
    private func legacyCopy(_ error: VCLError, errorCode: String, message: String? = nil) -> VCLError {
        VCLError(
            payload: error.payload,
            error: error.error,
            errorCode: errorCode,
            requestId: error.requestId,
            message: message ?? error.message,
            statusCode: error.statusCode,
            cause: error.cause
        )
    }
    
    private static let legacyMissingDidMessage = "did was not found in Velocity link"
}

private extension String {
    var mismatchErrorCode: String {
        self == ErrorTaxonomy.requestKindPresentation
            ? VCLErrorCode.MismatchedPresentationRequestInspectorDid.rawValue
            : VCLErrorCode.MismatchedRequestIssuerDid.rawValue
    }
    
    var endpointNullMessage: String {
        self == ErrorTaxonomy.requestKindPresentation
            ? "presentationRequestDescriptor.endpoint = null"
            : "credentialManifestDescriptor.endpoint = null"
    }
}
