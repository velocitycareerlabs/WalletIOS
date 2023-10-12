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
        case VCLEnvironment.Dev:
            return VCLEnvironment.Dev.rawValue
        case VCLEnvironment.Qa:
            return VCLEnvironment.Qa.rawValue
        case VCLEnvironment.Staging:
            return VCLEnvironment.Staging.rawValue
        default:
            return "" // prod is a default, doesn't has a prefix
        }
    } }
    
    private static var BaseUrlRegistrar: String { get { "https://\(EnvironmentPrefix)registrar.velocitynetwork.foundation" } }
//    private static var BaseUrlWalletApi: String { get { "https://\(EnvironmentPrefix)walletapi.velocitycareerlabs.io" } }
    
    static var CredentialTypes: String { get { "\(BaseUrlRegistrar)/api/v0.6/credential-types" } }
    static var CredentialTypeSchemas: String { get { "\(BaseUrlRegistrar)/schemas/" } }
    static var Countries: String { get { "\(BaseUrlRegistrar)/reference/countries" } }
    static var Organizations: String { get { "\(BaseUrlRegistrar)/api/v0.6/organizations/search-profiles" } }
    static var ResolveKid: String { get { "\(BaseUrlRegistrar)/api/v0.6/resolve-kid/" } }
    static var CredentialTypesFormSchema: String { get { "\(BaseUrlRegistrar)/api/v0.6/form-schemas?credentialType=\(Params.CredentialType)" } }
    static var VerifiedProfile: String { get { "\(BaseUrlRegistrar)/api/v0.6/organizations/\(Params.Did)/verified-profile" } }
}

struct Params {
    static let Did = "{did}"
    static let CredentialType = "{credentialType}"
}

struct HeaderKeys {
    static let Authorization = "Authorization"
    static let Bearer = "Bearer"
    static let XVnfProtocolVersion = "x-vnf-protocol-version"
}

struct HeaderValues {
    static var XVnfProtocolVersion: String { get { GlobalConfig.XVnfProtocolVersion.rawValue } }
}
