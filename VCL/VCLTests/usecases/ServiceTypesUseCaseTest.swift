//
//  ServiceTypesUseCaseTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 29/10/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

final class ServiceTypesUseCaseTest: XCTestCase {
    
    var subject: ServiceTypesUseCase!
    
    private let CredentialgroupAllowedValues = ["Career", "IdDocument", "Contact", ""]
    
    override func setUp() {
        subject = ServiceTypesUseCaseImpl(
            ServiceTypesRepositoryImpl(
                NetworkServiceSuccess(validResponse: ServiceTypesMocks.ServiceTypesJsonStr),
                EmptyCacheService()
            ),
            EmptyExecutor()
        )
    }
    
    func testGetServiceTypes() {
        subject.getServiceTypes(cacheSequence: 1) { [weak self] in
            do{
                let serviceTypes = try $0.get()
                assert(serviceTypes.all.count == 10)
                serviceTypes.all.forEach { serviceType in
                    assert(self?.CredentialgroupAllowedValues.contains(serviceType.credentialGroup) == true)
                }
                
            } catch {
                XCTFail("\(error)")
            }
        }
    }
}
