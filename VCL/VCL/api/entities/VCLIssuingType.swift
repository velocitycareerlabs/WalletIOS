//
//  VCLIssuingType.swift
//  VCL
//
//  Created by Michael Avoyan on 16/02/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public enum VCLIssuingType: String, Sendable {
    case Career = "Career"
    case Identity = "Identity"
    case Refresh = "Refresh"
    case Undefined = "Undefined"
    
    public static func fromString(value: String) -> VCLIssuingType {
        if(value.contains(VCLIssuingType.Career.rawValue)) {
            return VCLIssuingType.Career
        }
        if(value.contains(VCLIssuingType.Identity.rawValue)) {
            return VCLIssuingType.Identity
        }
        if(value.contains(VCLIssuingType.Refresh.rawValue)) {
            return VCLIssuingType.Refresh
        }
        return VCLIssuingType.Undefined
    }
}
