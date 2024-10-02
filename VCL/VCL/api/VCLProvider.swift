//
//  VCLProvider.swift
//  VCL
//
//  Created by Michael Avoyan on 20/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

public final class VCLProvider: Sendable {
    
    private init(){}
    
    public static func vclInstance() -> VCL {
        return VCLImpl()
    }
}
