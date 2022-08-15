//
//  OrganizationsRepositoryImpl.swift
//  
//
//  Created by Michael Avoyan on 18/04/2021.
//

import Foundation

class OrganizationsRepositoryImpl: OrganizationsRepository {
    
    private let networkService: NetworkService
    
    init(_ networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func searchForOrganizations(organizationsSearchDescriptor: VCLOrganizationsSearchDescriptor,
                               completionBlock: @escaping (VCLResult<VCLOrganizations>) -> Void) {
        var endpoint = Urls.Organizations
        if let qp = organizationsSearchDescriptor.queryParams {
            endpoint += "?" + qp
        }        
        networkService.sendRequest(
            endpoint: endpoint,
            contentType: .ApplicationJson,
            method: Request.HttpMethod.GET) {
            [weak self] response in
            do {
                let organizationsResponse = try response.get()
                if let organizations = self?.parse(organizationDict: organizationsResponse.payload.toDictionary()) {
                    completionBlock(.success(organizations))
                } else {
                    completionBlock(.failure(VCLError(description: "Failed to parse \(String(data: organizationsResponse.payload, encoding: .utf8) ?? "")")))
                }
            } catch {
                completionBlock(.failure(VCLError(error: error)))
            }
        }
    }
    
    private func parse(organizationDict: [String: Any]?) -> VCLOrganizations {
        var organizations = [VCLOrganization]()
        if let organizationsJsonArray = organizationDict?[VCLOrganizations.CodingKeys.KeyResult] as? [[String: Any]] {
            for i in 0..<organizationsJsonArray.count {
                organizations.append(VCLOrganization(payload: organizationsJsonArray[i]))
            }
        }
        return VCLOrganizations(all: organizations)
    }
}
