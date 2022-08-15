//
//  OrganizationIssuerRepository.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//

import Foundation

protocol OrganizationsRepository {
    func searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                                completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void)
}
