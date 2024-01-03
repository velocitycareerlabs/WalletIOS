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
    private let subject = VclBlocksProvider.self

    func testChooseServiceByDefault() {
        do {
            let keyService = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor()
            )
            assert(keyService is VCLKeyServiceLocalImpl)

            let jwtSignService = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor()
            )
            let jwtVerifyService = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor()
            )
            assert(keyService is VCLKeyServiceLocalImpl)
            assert(jwtSignService is VCLJwtSignServiceLocalImpl)
            assert(jwtVerifyService is VCLJwtVerifyServiceLocalImpl)
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
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
            assert(keyService is VCLKeyServiceRemoteImpl)

            let jwtSignService = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
            assert(jwtSignService is VCLJwtSignServiceRemoteImpl)

            let jwtVerifyService = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
            assert(jwtVerifyService is VCLJwtVerifyServiceRemoteImpl)

            let jwtVerifyServiceVerifyUrlNull = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "")
                    )
                )
            )
            assert(jwtVerifyServiceVerifyUrlNull is VCLJwtVerifyServiceLocalImpl)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testChooseInjectedKeyService() {
        let injectedCryptoServicesDescriptor = VCLInjectedCryptoServicesDescriptor(
            keyService: VCLKeyServiceMock(),
            jwtSignService: VCLJwtSignServiceMock(),
            jwtVerifyService: VCLJwtVerifyServiceMock()
        )

        do {
            let keyService = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: injectedCryptoServicesDescriptor
                )
            )
            assert(keyService is VCLKeyServiceMock)

            let jwtSignService = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: injectedCryptoServicesDescriptor
                )
            )
            assert(jwtSignService is VCLJwtSignServiceMock)

            let jwtVerifyService = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: injectedCryptoServicesDescriptor
                )
            )
            assert(jwtVerifyService is VCLJwtVerifyServiceMock)

            let jwtVerifyServiceNull = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtSignService: VCLJwtSignServiceMock()
                    )
                )
            )
            assert(jwtVerifyServiceNull is VCLJwtVerifyServiceLocalImpl)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testChooseRemoteServiceError1() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Remote)
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Remote)
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Remote)
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testChooseInjectedServiceError1() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Injected)
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Injected)
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(cryptoServiceType: VCLCryptoServiceType.Injected)
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testChooseRemoteServiceError2() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtSignService: VCLJwtSignServiceMock(),
                        jwtVerifyService: VCLJwtVerifyServiceMock()
                    )
                )
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtSignService: VCLJwtSignServiceMock(),
                        jwtVerifyService: VCLJwtVerifyServiceMock()
                    )
                )
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Remote,
                    injectedCryptoServicesDescriptor: VCLInjectedCryptoServicesDescriptor(
                        keyService: VCLKeyServiceMock(),
                        jwtSignService: VCLJwtSignServiceMock(),
                        jwtVerifyService: VCLJwtVerifyServiceMock()
                    )
                )
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testChooseInjectedServiceError2() {
        do {
            _ = try subject.chooseKeyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtSignService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
        
        do {
            _ = try subject.chooseJwtVerifyService(
                VCLCryptoServicesDescriptor(
                    cryptoServiceType: VCLCryptoServiceType.Injected,
                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
                        keyServiceUrls: VCLKeyServiceUrls(createDidKeyServiceUrl: ""),
                        jwtServiceUrls: VCLJwtServiceUrls(jwtSignServiceUrl: "", jwtVerifyServiceUrl: "")
                    )
                )
            )
        } catch let error as VCLError {
            assert(error.errorCode == VCLErrorCode.InjectedServicesNotFount.rawValue)
        } catch {
            XCTFail("\(error)")
        }
    }
}
