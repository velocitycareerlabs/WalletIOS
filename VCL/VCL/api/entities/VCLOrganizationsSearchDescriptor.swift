//
//  VCLOrganizationsSearchDescriptor.swift
//  
//
//  Created by Michael Avoyan on 06/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLOrganizationsSearchDescriptor {
    public let filter: VCLFilter?
    public let page: VCLPage?
    /// A array of tuples indicating the field to sort by
    public let sort: [[String]]?
    /// Full Text search for the name property of the organization
    /// Matches on partials strings
    /// Prefer results that are the first word of the name, or first letter of a word
    public let query: String?
    
    public init(filter: VCLFilter? = nil, page: VCLPage? = nil, sort: [[String]]? = nil, query: String? = nil) {
        self.filter = filter
        self.page = page
        self.sort = sort
        self.query = query
    }

    public var queryParams: String? { get { generateQueryParams() } }
    
    private func generateQueryParams() -> String? {
        var pFilterDid: String? = nil
        var pFilterServiceTypes: String? = nil
        var pFilterCredentialTypes: String? = nil
        var pSort: String? = nil
        var pPageSkip: String? = nil
        var pPageSize: String? = nil
        var pQuery: String? = nil
        
        if let filterDid = self.filter?.did {
            pFilterDid = "\(CodingKeys.KeyFilterDid)=\(filterDid)"
        }
        if let serviceTypes = self.filter?.serviceTypes {
            pFilterServiceTypes = "\(CodingKeys.KeyFilterServiceTypes)=\(serviceTypes.map{ $0.rawValue }.joined(separator: ","))"
        }
        if let credentialTypes = self.filter?.credentialTypes {
            pFilterCredentialTypes = "\(CodingKeys.KeyFilterCredentialTypes)=\(credentialTypes.map{ $0.encode() ?? "" }.joined(separator: ","))"
        }
        if let sort = self.sort {
            pSort = "\(sort.enumerated().map{ (index, list) in "\(CodingKeys.KeySort)[\(index)]=\(list.map{ $0.encode() ?? "" }.joined(separator: ","))" }.joined(separator: "&"))"
        }
        if let skip = self.page?.skip?.encode() {
            pPageSkip = "\(CodingKeys.KeyPageSkip)=\(skip)"
        }
        if let size = self.page?.size?.encode() {
            pPageSize = "\(CodingKeys.KeyPageSize)=\(size)"
        }
        if let query = self.query?.encode() {
            pQuery = "\(CodingKeys.KeyQueryQ)=\(query )"
        }
        let qParams = [
            pFilterDid,
            pFilterServiceTypes,
            pFilterCredentialTypes,
            pSort,
            pPageSkip,
            pPageSize,
            pQuery
        ].compactMap{ $0 }
        if qParams.isEmpty { return nil }
        else { return qParams.joined(separator: "&") }
    }
    
    private struct CodingKeys {
        public static let KeyQueryQ = "q"

        public static let KeySort = "sort"

        public static let KeyFilterDid = "filter.did"
        public static let KeyFilterServiceTypes = "filter.serviceTypes"
        public static let KeyFilterCredentialTypes = "filter.credentialTypes"

        public static let KeyPageSkip = "page.skip"
        public static let KeyPageSize = "page.size"
    }
}

public struct VCLFilter {
    /// Filters organizations based on DIDs
    let did: String?
    /// Filters organizations based on Service Types e.g. [VCLServiceType]
    let serviceTypes: [VCLServiceType]?
    /// Filters organizations based on credential types e.g. [EducationDegree]
    let credentialTypes: [String]?
    
    public init(
        did: String? = nil,
        serviceTypes: [VCLServiceType]? = nil,
        credentialTypes: [String]? = nil
    ) {
        self.did = did
        self.serviceTypes = serviceTypes
        self.credentialTypes = credentialTypes
    }
}

public struct VCLPage {
    /// The number of records to retrieve
    let size: String?
    /// The objectId to skip
    let skip: String?
    
    public init(size: String?, skip: String?) {
        self.size = size
        self.skip = skip
    }
}
