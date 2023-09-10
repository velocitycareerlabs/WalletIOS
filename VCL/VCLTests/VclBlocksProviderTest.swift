//
//  VclBlocksProviderTest.swift
//  VCLTests
//
//  Created by Michael Avoyan on 10/09/2023.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation
import XCTest
@testable import VCL

class VclBlocksProviderTest: XCTestCase {
    let subject = VclBlocksProvider.self
    
    func testChooseServiceByDefault() {
        do {
            let keyService = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor()
            )
            assert(keyService is VCLKeyServiceLocalImpl)
            
            let jwtService = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor()
            )
            assert(keyService is VCLKeyServiceLocalImpl)
            assert(jwtService is VCLJwtServiceLocalImpl)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testChooseRemoteService() {
        do {
            let keyService = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(keyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
            assert(keyService is VCLKeyServiceRemoteImpl)
            
            let jwtService = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(keyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
            assert(jwtService is VCLJwtServiceRemoteImpl)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testChooseInjectedKeyService() {
        do {
            let keyService = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtService: VCLJwtServiceMock()
                    )
                )
            )
            assert(keyService is VCLKeyServiceMock)
            
            let jwtService = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtService: VCLJwtServiceMock()
                    )
                )
            )
            assert(jwtService is VCLJwtServiceMock)
        } catch {
            XCTFail("\(error)")
        }
    }
    
    func testChooseRemoteServiceError1() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Remote)
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        }
        
        do {
            _ = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Remote)
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        }
    }
    
    func testChooseInjectedServiceError1() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Injected)
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        }
        
        do {
            _ = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Injected)
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        }
    }
    
    func testChooseRemoteServiceError2() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtService: VCLJwtServiceMock()
                    )
                )
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        }
        
        do {
            _ = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtService: VCLJwtServiceMock()
                    )
                )
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        }
    }

    func testChooseInjectedServiceError2() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(keyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        }

        do {
            _ = try subject.chooseJwtService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(keyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
        } catch {
            assert((error as! VCLError).errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        }
    }
}
