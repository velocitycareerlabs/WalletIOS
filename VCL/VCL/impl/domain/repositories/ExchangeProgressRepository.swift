//
//  ExchangeProgressRepository.swift
//  VCL
//
//  Created by Michael Avoyan on 30/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol ExchangeProgressRepository {
    func getExchangeProgress(exchangeDescriptor: VCLExchangeDescriptor,
                             completionBlock: @escaping  (VCLResult<VCLExchange>) -> Void)
}
