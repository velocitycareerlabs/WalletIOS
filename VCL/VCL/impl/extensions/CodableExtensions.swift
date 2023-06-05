//
//  CodableExtensions.swift
//  VCL
//
//  Created by Michael Avoyan on 07/03/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

extension Encodable {

    /// Converting object to postable dictionary
    func toDictionary(_ encoder: JSONEncoder = JSONEncoder()) throws -> [String: Any] {
        let data = try encoder.encode(self)
        let object = try JSONSerialization.jsonObject(with: data)
        guard let retVal = object as? [String: Any] else {
            let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
            throw DecodingError.typeMismatch(type(of: object), context)
        }
        return retVal
    }
    
    func toDictionaryOpt(_ encoder: JSONEncoder = JSONEncoder()) -> [String: Any]? {
        do {
            let data = try encoder.encode(self)
            let object = try JSONSerialization.jsonObject(with: data)
            guard let retVal = object as? [String: Any] else {
                let context = DecodingError.Context(codingPath: [], debugDescription: "Deserialized object is not a dictionary")
                throw DecodingError.typeMismatch(type(of: object), context)
            }
            return retVal
        } catch {
            VCLLog.e(error)
        }
        return nil
    }
}
