//
//  FinalizeOffersRepository.swift
//  
//
//  Created by Michael Avoyan on 12/05/2021.
//

import Foundation

protocol FinalizeOffersRepository {
    func finalizeOffers(token: VCLToken,
                        finalizeOffersDescriptor: VCLFinalizeOffersDescriptor,
                        completionBlock: @escaping (VCLResult<[String]>) -> Void)
}
