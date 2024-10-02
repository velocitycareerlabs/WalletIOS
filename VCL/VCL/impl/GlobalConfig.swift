//
//  GlobalConfig.swift
//  VCL
//
//  Created by Michael Avoyan on 16/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

struct GlobalConfig {
    static let VclPackage = "io.velocitycareerlabs"
    
    nonisolated(unsafe) static var CurrentEnvironment = VCLEnvironment.Prod
    nonisolated(unsafe) static var XVnfProtocolVersion = VCLXVnfProtocolVersion.XVnfProtocolVersion1
        
    nonisolated(unsafe) static var KeycahinAccessGroupIdentifier: String? = nil
    
    #if DEBUG
    nonisolated(unsafe) static var IsDebugOn = false
    #else
    nonisolated(unsafe) static var IsDebugOn = false
    #endif
    
    nonisolated(unsafe) static let Build = Bundle(for: VCLImpl.self).infoDictionary?["CFBundleVersion"] ?? ""
    nonisolated(unsafe) static let Version = Bundle(for: VCLImpl.self).infoDictionary?["CFBundleShortVersionString" ] ?? ""
    
    static let LogTagPrefix = "VCL "

    static var IsLoggerOn: Bool { get { (CurrentEnvironment != VCLEnvironment.Staging && CurrentEnvironment != VCLEnvironment.Prod) || IsDebugOn } }
    
    static let TypeJwt = "JWT"
}
