//
//  VCLXVnfProtocolVersion.swift
//  VCL
//
//  Created by Michael Avoyan on 20/07/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLXVnfProtocolVersion: String, Sendable {
    case XVnfProtocolVersion1 = "1.0"
    case XVnfProtocolVersion2 = "2.0"
    
    public static func fromString(value: String) -> VCLXVnfProtocolVersion {
        switch(value) {
        case VCLXVnfProtocolVersion.XVnfProtocolVersion1.rawValue:
            return .XVnfProtocolVersion1
        case VCLXVnfProtocolVersion.XVnfProtocolVersion2.rawValue:
            return .XVnfProtocolVersion2
        default:
            return .XVnfProtocolVersion1
        }
    }
}
