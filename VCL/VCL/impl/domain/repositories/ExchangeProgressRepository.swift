//
//  ExchangeProgressRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//

import Foundation

protocol ExchangeProgressRepository {
    func getExchangeProgress(exchangeDescriptor: VCLExchangeDescriptor,
                             completionBlock: @escaping  (VCLResult<VCLExchange>) -> Void)
}
