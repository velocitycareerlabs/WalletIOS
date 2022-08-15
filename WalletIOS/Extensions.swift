//
//  Extensions.swift
//  WalletIOS
//
//  Created by Michael Avoyan on 09/08/2021.
//

import Foundation

public extension String {
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
}
