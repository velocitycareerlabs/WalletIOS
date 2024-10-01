//
//  VCLEnvironment.swift
//  VCL
//
//  Created by Michael Avoyan on 15/09/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLEnvironment: String, Sendable {
    case Prod = "prod"
    case Staging = "staging"
    case Qa = "qa"
    case Dev = "dev"
    
    public static func fromString(value: String) -> VCLEnvironment {
        switch(value) {
        case VCLEnvironment.Prod.rawValue:
            return .Prod
        case VCLEnvironment.Staging.rawValue:
            return .Staging
        case VCLEnvironment.Qa.rawValue:
            return .Qa
        case VCLEnvironment.Dev.rawValue:
            return .Dev
        default:
            return .Prod
        }
    }
}
