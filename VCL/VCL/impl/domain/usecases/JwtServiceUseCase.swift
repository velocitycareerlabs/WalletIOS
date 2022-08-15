//
//  JwtServiceUseCase.swift
//  VCL
//
//  Created by Michael Avoyan on 15/06/2021.
//

import Foundation

protocol JwtServiceUseCase {
    func verifyJwt(jwt: VCLJWT, publicKey: VCLPublicKey, completionBlock: @escaping (VCLResult<Bool>) -> Void)
    func generateSignedJwt(payload: [String: Any], iss: String, completionBlock: @escaping (VCLResult<VCLJWT>) -> Void)
}
