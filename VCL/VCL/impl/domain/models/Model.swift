//
//  Model.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol Model: Sendable {
    var data: T? { get }
}

extension Model {
    typealias T = Sendable
    var data: Sendable? { nil }
}
