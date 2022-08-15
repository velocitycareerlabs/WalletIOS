//
//  VCLOrganizationsDescriptorTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 15/08/2021.
//

import Foundation
import XCTest
@testable import VCL

final class VCLOrganizationsDescriptorTest: XCTestCase {
    
    var subject: VCLOrganizationsSearchDescriptor!
    
    override func setUp() {
    }
    
    func testOrganizationsDescriptorAllParamsAggregationSuccess() {
        let organizationDescriptorQueryParamsMock = "filter.did=did:velocity:0x2bef092530ccc122f5fe439b78eddf6010685e88&" +
            "filter.serviceTypes=Inspector&" +
            "filter.credentialTypes=EducationDegree&" +
            "sort[0]=createdAt,DESC&sort[1]=pdatedAt,ASC&" +
            "page.skip=1&" +
            "page.size=1&q=Bank"
        subject = VCLOrganizationsSearchDescriptor(
            filter: VCLOrganizationsDescriptorMocks.Filter,
            page: VCLOrganizationsDescriptorMocks.Page,
            sort: VCLOrganizationsDescriptorMocks.Sort,
            query: VCLOrganizationsDescriptorMocks.Query
        )
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    func testOrganizationsDescriptorFilterPageSortParamsAggregationSuccess() {
        let organizationDescriptorQueryParamsMock = "filter.did=did:velocity:0x2bef092530ccc122f5fe439b78eddf6010685e88&" +
            "filter.serviceTypes=Inspector&" +
            "filter.credentialTypes=EducationDegree&" +
            "sort[0]=createdAt,DESC&sort[1]=pdatedAt,ASC&" +
            "page.skip=1&page.size=1"
        subject = VCLOrganizationsSearchDescriptor(
            filter: VCLOrganizationsDescriptorMocks.Filter,
            page: VCLOrganizationsDescriptorMocks.Page,
            sort: VCLOrganizationsDescriptorMocks.Sort
        )
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    func testOrganizationsDescriptorFilterPageQueryParamsAggregationSuccess() {
        let organizationDescriptorQueryParamsMock =
            "filter.did=did:velocity:0x2bef092530ccc122f5fe439b78eddf6010685e88&" +
            "filter.serviceTypes=Inspector&" +
            "filter.credentialTypes=EducationDegree&" +
            "page.skip=1&" +
            "page.size=1&" +
            "q=Bank"
        subject = VCLOrganizationsSearchDescriptor(
            filter: VCLOrganizationsDescriptorMocks.Filter,
            page: VCLOrganizationsDescriptorMocks.Page,
            query: VCLOrganizationsDescriptorMocks.Query
        )
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    func testOrganizationsDescriptorFilterSortQueryParamsAggregationSuccess() {
        let organizationDescriptorQueryParamsMock =
            "filter.did=did:velocity:0x2bef092530ccc122f5fe439b78eddf6010685e88&" +
            "filter.serviceTypes=Inspector&" +
            "filter.credentialTypes=EducationDegree&" +
            "sort[0]=createdAt,DESC&" +
            "sort[1]=pdatedAt,ASC&" +
            "q=Bank"
        subject = VCLOrganizationsSearchDescriptor(
            filter: VCLOrganizationsDescriptorMocks.Filter,
            sort: VCLOrganizationsDescriptorMocks.Sort,
            query: VCLOrganizationsDescriptorMocks.Query
        )
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    func testOrganizationsDescriptorPageSortQueryParamsAggregationSuccess() {
        let organizationDescriptorQueryParamsMock =
            "sort[0]=createdAt,DESC&" +
            "sort[1]=pdatedAt,ASC&" +
            "page.skip=1&" +
            "page.size=1&" +
            "q=Bank"
        subject = VCLOrganizationsSearchDescriptor(
            page: VCLOrganizationsDescriptorMocks.Page,
            sort: VCLOrganizationsDescriptorMocks.Sort,
            query: VCLOrganizationsDescriptorMocks.Query
        )
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    func testOrganizationsDescriptorDidFilterAggregationSuccess() {
        let organizationDescriptorQueryParamsMock = "filter.did=did:velocity:0x2bef092530ccc122f5fe439b78eddf6010685e88"
        subject = VCLOrganizationsSearchDescriptor(filter: VCLFilter(did: VCLOrganizationsDescriptorMocks.Filter.did))
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    func testOrganizationsDescriptorNoParamsAggregationSuccess() {
        let organizationDescriptorQueryParamsMock: String? = nil
        subject = VCLOrganizationsSearchDescriptor()
        
        assert(subject.queryParams == organizationDescriptorQueryParamsMock)
    }
    
    override func tearDown() {
    }
}
