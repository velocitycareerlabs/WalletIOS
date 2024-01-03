//
//  VCLErrorCodes.swift
//  VCL
//
//  Created by Michael Avoyan on 16/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLErrorCode: String {
    // Initialization
    case RemoteServicesUrlsNotFount = "remote_services_urls_not_found"
    case InjectedServicesNotFount = "injected_services_not_found"
    // Credential issuer verification error codes
    case CredentialTypeNotRegistered = "credential_type_not_registered"
    case IssuerRequiresIdentityPermission = "issuer_requires_identity_permission"
    case IssuerRequiresNotaryPermission = "issuer_requires_notary_permission"
    case InvalidCredentialSubjectType = "invalid_credential_subject_type"
    case InvalidCredentialSubjectContext = "invalid_credential_subject_context"
    case IssuerUnexpectedPermissionFailure = "issuer_unexpected_permission_failure"
    // DID consistent with the Deep Link
    case MismatchedRequestIssuerDid = "mismatched_request_issuer_did"
    case MismatchedOfferIssuerDid = "mismatched_offer_issuer_did"
    case MismatchedCredentialIssuerDid = "mismatched_credential_issuer_did"
    case MismatchedPresentationRequestInspectorDid = "mismatched_presentation_request_inspector_did"
    // General error
    case SdkError = "sdk_error"
}
