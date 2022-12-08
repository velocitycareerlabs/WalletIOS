//
//  StringExtensions.swift
//
//
//  Created by Michael Avoyan on 18/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

extension String {
    func toQueryString() -> String? {
        var urlVars:[String] = []
        guard let parameters = self.toDictionary() else {return nil}
        
        for (key, value) in parameters {
            let value = value as? String
            if let encodedValue = value?.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                urlVars.append(key + "=" + encodedValue)
            }
        }
        return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
    }
    
    func toDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
//                VCLLog.error(error)
            }
        }
        return nil
    }
    
    func toList() -> [Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [Any]
            } catch {
//                VCLLog.error(error)
            }
        }
        return nil
    }
    
    func toListOfDictionaries() -> [[String: Any]]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            } catch {
//                VCLLog.error(error)
            }
        }
        return nil
    }
    
    func appendQueryParams(queryParams: String) -> String {
        if let urlComponents = URLComponents(string: self) {
            if (urlComponents.queryItems != nil) {
                return "\(self)&\(queryParams)"
            } else {
                return "\(self)?\(queryParams)"
            }
        }
        return "\(self)?\(queryParams)"
    }
    
    func encode() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }
    
    func decode() -> String? {
        return self.removingPercentEncoding
    }
    
    func decodeBase64() -> String? {
        guard let data =
                Data(base64Encoded: self)
//                Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0))
        else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    func decodeBase64URL() -> String? {
        var base64 = self
        base64 = base64.replacingOccurrences(of: "-", with: "+")
        base64 = base64.replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {
            base64 = base64.appending("=")
        }
        guard let data = Data(base64Encoded: base64) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    
    func decodeJwtBase64Url() -> [String] {
        var retVal = [String]()
        let base64Parts = self.split(separator: ".").map{ String($0) }
        if base64Parts.count >= 1, let decoded = base64Parts[0].decodeBase64URL() {
            retVal.append(decoded)
        } else {
            retVal.append("")
        }
        if base64Parts.count >= 2, let decoded = base64Parts[1].decodeBase64URL() {
            retVal.append(decoded)
        } else {
            retVal.append("")
        }
        if base64Parts.count >= 3 {
            retVal.append(base64Parts[2]) // sha256
        } else {
            retVal.append("")
        }
        return retVal
    }
    
    func encodeToBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func toData() -> Data {
        return self.data(using: .utf8) ?? Data()
    }
    
    func getUrlQueryParams() -> [String: String]? {
        var dict: [String: String]? = nil
        if let queryItems = URLComponents(string: self)?.queryItems {
            dict = [String: String]()
            for (queryItem) in queryItems {
                dict?[queryItem.name] = queryItem.value
            }
        }
        return dict
    }
    
    func removePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func removeFirstSuffix(_ suffixStart: String) -> String {
        guard self.contains(suffixStart) else { return self }
        var components = self.components(separatedBy: suffixStart)
        if components.count > 0 {
          components.removeLast()
          return components[0]
        } else {
          return self
        }
    }
}

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}
