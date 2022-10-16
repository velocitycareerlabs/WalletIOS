//
//  OrganizationIssuerRepository.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

protocol OrganizationsRepository {
    func searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                                completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void)
}
