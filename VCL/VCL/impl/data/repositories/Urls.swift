//
//  Constants.swift
//  VCL
//
//  Created by Michael Avoyan on 18/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

struct Urls {
    private static var EnvironmentPrefix: String { get {
        switch GlobalConfig.CurrentEnvironment {
        case VCLEnvironment.DEV:
            return VCLEnvironment.DEV.rawValue
        case VCLEnvironment.QA:
            return VCLEnvironment.QA.rawValue
        case VCLEnvironment.STAGING:
            return VCLEnvironment.STAGING.rawValue
        default:
            return "" // prod is a default, doesn't has a prefix
        }
    } }
    
    private static var BaseUrlServices: String { get { "https://\(EnvironmentPrefix)registrar.velocitynetwork.foundation" } }
    static var CredentialTypes: String { get { "\(BaseUrlServices)/api/v0.6/credential-types" } }
    static var CredentialTypeSchemas: String { get { "\(BaseUrlServices)/schemas/" } }
    static var Countries: String { get { "\(BaseUrlServices)/reference/countries" } }
    static var Organizations: String { get { "\(BaseUrlServices)/api/v0.6/organizations/search-profiles" } }
    static var ResolveKid: String { get { "\(BaseUrlServices)/api/v0.6/resolve-kid/" } }
    static var CredentialTypesFormSchema: String { get { "\(BaseUrlServices)/api/v0.6/form-schemas?credentialType=\(Params.CredentialType)" } }
    static var VerifiedProfile: String { get { "\(BaseUrlServices)/api/v0.6/organizations/\(Params.Did)/verified-profile" } }
}

struct Params {
    static let Did = "{did}"
    static let CredentialType = "{credentialType}"
}

struct HeaderKeys {
    static let HeaderKeyAuthorization = "Authorization"
    static let HeaderValuePrefixBearer = "Bearer"
    static let XVnfProtocolVersion = "x-vnf-protocol-version"
}

struct HeaderValues {
    static var XVnfProtocolVersion: String { get { GlobalConfig.XVnfProtocolVersion.rawValue } }
}
