//
//  URLExtensions.swift
//  
//
//  Created by Michael Avoyan on 03/04/2021.
//

import Foundation

extension URL {
    func getUrlQueryParams() -> [String: String] {
        var dict = [String:String]()
        if let components = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            if let queryItems = components.queryItems {
                for item in queryItems {
                    if let value = item.value {
                        dict[item.name] = value
                    }
                }
            }
        }
        return dict
    }
}
