//
//  Response.swift
//  VCL
//
//  Created by Michael Avoyan on 01/11/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

struct Response {
    let payload: Data
    let code: Int
    
    init(payload: Data, code: Int) {
        self.payload = payload
        self.code = code
    }
}
