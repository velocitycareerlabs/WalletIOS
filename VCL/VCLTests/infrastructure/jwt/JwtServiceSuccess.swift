//
//  JwtServiceSuccess.swift
//  
//
//  Created by Michael Avoyan on 04/05/2021.
//

import Foundation
@testable import VCL

class JwtServiceSuccess: JwtService {
    
    let VclJwt: VCLJWT!
    
    init(VclJwt: VCLJWT) {
        self.VclJwt = VclJwt
    }
    
    func decode(encodedJwt: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        completionBlock(.success(self.VclJwt))
    }
    
    func encode(jwt: String, completionBlock: @escaping (VCLResult<String>) -> Void) {
    }
    
    func verify(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void) {
        completionBlock(.success(true))
    }
    
    func sign(payload: [String :Any], iss: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void) {
        completionBlock(.success(VCLJWT(header: nil, payload: nil, signature: nil, encodedJwt: JwtServiceMocks.SignedJwt)))
    }
    
}
