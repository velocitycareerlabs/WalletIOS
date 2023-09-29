//
//  GlobalConfigTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 07/10/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class GlobalConfigTest: XCTestCase {
    
    override func setUp() {
    }
    
    func testDevEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Dev
        assert(GlobalConfig.IsLoggerOn)
        
        GlobalConfig.IsDebugOn = true
        assert(GlobalConfig.IsLoggerOn)

        GlobalConfig.IsDebugOn = false
        assert(GlobalConfig.IsLoggerOn)
    }
    
    func testQaEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Qa
        assert(GlobalConfig.IsLoggerOn)
        
        GlobalConfig.IsDebugOn = true
        assert(GlobalConfig.IsLoggerOn)

        GlobalConfig.IsDebugOn = false
        assert(GlobalConfig.IsLoggerOn)
    }
    
    func testStagingEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Staging
        assert(!GlobalConfig.IsLoggerOn)
        
        GlobalConfig.IsDebugOn = true
        assert(GlobalConfig.IsLoggerOn)

        GlobalConfig.IsDebugOn = false
        assert(!GlobalConfig.IsLoggerOn)
    }
    
    func testProdEnvironment() {
        GlobalConfig.CurrentEnvironment = VCLEnvironment.Prod
        assert(!GlobalConfig.IsLoggerOn)
        
        GlobalConfig.IsDebugOn = true
        assert(GlobalConfig.IsLoggerOn)

        GlobalConfig.IsDebugOn = false
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


