//
//  OrganizationsUseCaseImpl.swift
//  
//
//  Created by Michael Avoyan on 07/05/2021.
//

import Foundation

protocol OrganizationsUseCase {
    func searchForOrganizations(
        organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                                completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void
    )
}
