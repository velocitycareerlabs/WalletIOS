//
//  DataExtensions.swift
//  VCL
//
//  Created by Michael Avoyan on 17/03/2021.
//

import Foundation

extension Data {
    func toDictionary() -> [String: Any]? {
        var retVal: [String: Any]? = nil
        do {
            retVal = try JSONSerialization.jsonObject(
                with: self,
                options: []
            ) as? [String : Any]
        }
        catch {
            // VCLLog.error(error)
        }
        return retVal
    }
    
    func toList() -> [Any]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [Any]
        } catch {
//            VCLLog.e(error)
        }
        return nil
    }
    
    func toListOfDictionaries() -> [[String: Any]]? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: []) as? [[String: Any]]
        } catch {
            // VCLLog.e(error)
        }
        return nil
    }
}
