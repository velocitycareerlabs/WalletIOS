//
//  OrganizationsUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 07/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

protocol OrganizationsUseCase {
    func searchForOrganizations(
        organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
        completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void
    )
}
