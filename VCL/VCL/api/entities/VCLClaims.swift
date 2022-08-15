//
//  VCLClaims.swift
//  VCL
//
//  Created by Michael Avoyan on 03/06/2021.
//

import Foundation
import VCToken

public struct VCLClaims: Claims, Decodable, Encodable {
    
    public let all: [String: Any]
    
    public init(from decoder: Decoder) throws {
        self.all = [String : Any]()
//        VCLLog.d("Dummy implementation")
    }
    
    public func encode(to encoder: Encoder) throws {
//        VCLLog.d("Empty implementation")
    }
    
    public init(all: [String : Any]) {
        self.all = all
    }
    
    public var iat: Double? {
        return self.all["iat"] as? Double
    }
    
    public var exp: Double? {
        return self.all["exp"] as? Double
    }
    
    public var nbf: Double? {
        return self.all["nbf"] as? Double
    }
}
