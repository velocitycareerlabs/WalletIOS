//
//  DataExtensions.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension Data {
    func toDictionary() -> [String: Sendable]? {
        var retVal: [String: Sendable]? = nil
        do {
            retVal = try JSONSerialization.jsonObject(
                with: self,
                options: []
            ) as? [String : Sendable]
        }
        catch {
            // VCLLog.error(error)
        }
        return retVal
    }
    
    func toList() -> [Sendable]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [Sendable]
        } catch {
//            VCLLog.e(error)
        }
        return nil
    }
    
    func toListOfDictionaries() -> [[String: Sendable]]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [[String: Sendable]]
        } catch {
            // VCLLog.e(error)
        }
        return nil
    }
    
    func toBool() -> Bool? {
        return String(data: self, encoding: .utf8).flatMap(Bool.init)
    }
    
    func toString() -> String? {
        return String(data: self, encoding: .utf8)
    }
    
    func toJwtList() -> [VCLJwt]? {
        if let jsonArray = try? JSONSerialization.jsonObject(with: self) as? [String] {
            var jwtCredentials = [VCLJwt]()
            for jwtEncodedCredential in jsonArray {
                let jwt = VCLJwt(encodedJwt: jwtEncodedCredential)
                jwtCredentials.append(jwt)
            }
            return jwtCredentials
        }
        return nil
    }
}
