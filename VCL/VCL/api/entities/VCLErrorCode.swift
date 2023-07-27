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
    // Credential issuer verification error codes:
    case CredentialTypeNotRegistered = "credential_type_not_registered"
    case IssuerRequiresIdentityPermission = "issuer_requires_identity_permission"
    case IssuerRequiresNotaryPermission = "issuer_requires_notary_permission"
    case InvalidCredentialSubjectType = "invalid_credential_subject_type"
    case InvalidCredentialSubjectContext = "invalid_credential_subject_context"
    case IssuerUnexpectedPermissionFailure = "issuer_unexpected_permission_failure"
}
