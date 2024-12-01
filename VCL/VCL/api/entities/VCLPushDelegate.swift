//
//  VCLPushDelegate.swift
//  
//
//  Created by Michael Avoyan on 09/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLPushDelegate {
    /// the url of the endpoint that will send pushes to the device
    public let pushUrl: String
    /// the token to use for identifying the group of devices this device belongs to
    public let pushToken: String
    
    public init(
        pushUrl: String,
        pushToken: String
    ) {
        self.pushUrl = pushUrl
        self.pushToken = pushToken
    }
    
    func toDictionary() -> [String: String] {
        var retVal = [String: String]()
        retVal[CodingKeys.KeyPushUrl] = pushUrl
        retVal[CodingKeys.KeyPushToken] = pushToken
        return retVal
    }
    
    func toPropsString() -> String {
        var propsString = ""
        propsString += "\npushUrl: \(pushUrl)"
        propsString += "\npushToken: \(pushToken)"
        return propsString
    }
    
    public struct CodingKeys {
        public static let KeyPushUrl = "pushUrl"
        public static let KeyPushToken = "pushToken"
    }
}
