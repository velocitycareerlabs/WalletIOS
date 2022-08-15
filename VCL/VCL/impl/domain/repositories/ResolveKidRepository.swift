//
//  ResolveKidRepository.swift
//  
//
//  Created by Michael Avoyan on 20/04/2021.
//

import Foundation

protocol ResolveKidRepository {
    func getPublicKey(keyID: String, completionBlock: @escaping (VCLResult<VCLPublicKey>) -> Void)
}
