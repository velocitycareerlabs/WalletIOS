//
//  VCLPlace.swift
//  VCL
//
//  Created by Michael Avoyan on 23/02/2022.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public protocol VCLPlace {
    var payload: [String: Any] { get }
    var code: String  { get }
    var name: String  { get }
}
