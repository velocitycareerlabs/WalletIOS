//
//  GenerateOffersRepository.swift
//  
//
//  Created by Michael Avoyan on 11/05/2021.
//

import Foundation

protocol GenerateOffersRepository {
    func generateOffers(token: VCLToken,
                        generateOffersDescriptor: VCLGenerateOffersDescriptor,
                        completionBlock: @escaping (VCLResult<VCLOffers>) -> Void)
}
