//
//  GlobalConfig.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import UIKit

struct GlobalConfig {
    static let VclPackage = "io.velocitycareerlabs"
    
    static var CurrentEnvironment = VCLEnvironment.Prod
    static var XVnfProtocolVersion = VCLXVnfProtocolVersion.XVnfProtocolVersion1
    
    static var KeycahinAccessGroupIdentifier: String? = nil
    
    #if DEBUG
        static var IsDebug = false // true
    #else
        static var IsDebug = false
    #endif
    
    static let Build = Bundle(for: VCLImpl.self).infoDictionary?["CFBundleVersion"] ?? ""
    static let Version = Bundle(for: VCLImpl.self).infoDictionary?["CFBundleShortVersionString" ] ?? ""
    
    static let LogTagPrefix = "VCL "
    // TODO: Will be remotely configurable
    static var IsLoggerOn: Bool { get { CurrentEnvironment != VCLEnvironment.Prod || GlobalConfig.IsDebug } }
    
    static let AlgES256K = "ES256K"
    static let TypeJwt = "JWT"
}
