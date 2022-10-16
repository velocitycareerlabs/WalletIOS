//
//  VCLPushDelegate.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLPushDelegate {
    public let pushUrl: String
    public let pushToken: String
    
    public init(pushUrl: String, pushToken: String) {
        self.pushUrl = pushUrl
        self.pushToken = pushToken
    }
}
