//
//  GlobalConfigTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 07/10/2021.
//

import Foundation
import XCTest
@testable import VCL

class GlobalConfigTest: XCTestCase {
    
    override func setUp() {
    }
    
    func testDevEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.DEV
        
        assert(GlobalConfig.IsLoggerOn)
    }
    
    func testStagingEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.STAGING
        
        assert(GlobalConfig.IsLoggerOn)
    }
    
    func testProdEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.PROD
        
        assert(!GlobalConfig.IsLoggerOn)
    }
    
    func testPackageName() {
        assert(GlobalConfig.VclPackage == "io.velocitycareerlabs")
    }
    
    func testAlgES256K() {
        assert(GlobalConfig.AlgES256K == "ES256K")
    }
    
    func testTypeJwt() {
        assert(GlobalConfig.TypeJwt == "JWT")
    }
               
    func testLogTagPrefix() {
        assert(GlobalConfig.LogTagPrefix == "VCL ")
    }
    
    override func tearDown() {
    }
}


