//
//  Model.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol Model {
    var data: T? { get }
}

extension Model {
    typealias T = Any
    var data: Any? { nil }
}
