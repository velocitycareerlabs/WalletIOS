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
    
    static var CurrentEnvironment = VCLEnvironment.PROD
    
    #if DEBUG
        static let IsDebug = false // true
    #else
        static let IsDebug = false
    #endif
    
    static let Build = Bundle(for: VCLImpl.self).infoDictionary?["CFBundleVersion"] ?? ""
    static let Version = Bundle(for: VCLImpl.self).infoDictionary?["CFBundleShortVersionString" ] ?? ""
    
    static let LogTagPrefix = "VCL "
    // TODO: Will be remotely configurable
    static var IsLoggerOn: Bool { get { CurrentEnvironment != VCLEnvironment.PROD } }
    
    // TODO: Will be remotely configurable
    var IsToLoadFromCacheInitialization = false
    
    static let AlgES256K = "ES256K"
    static let TypeJwt = "JWT"
}
