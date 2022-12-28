//
//  VCLJwtDescriptor.swift
//  VCL
//
//  Created by Michael Avoyan on 27/12/2022.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public class VCLJwtDescriptor {
    let payload: [String: Any]
    let iss: String
    let jti:String
    
    public init(payload: [String : Any], iss: String, jti: String) {
        self.payload = payload
        self.iss = iss
        self.jti = jti
    }
}
