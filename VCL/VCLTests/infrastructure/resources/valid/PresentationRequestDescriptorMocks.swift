//
//  PresentationRequestDescriptorMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 05/12/2022.
//

import Foundation
@testable import VCL

public class PresentationRequestDescriptorMocks {

    static let InspectorDid = "did:velocity:0xd4df29726d500f9b85bc6c7f1b3c021f16305692"

    static let RequestUri =
        "https%3A%2F%2Fdevagent.velocitycareerlabs.io%2Fapi%2Fholder%2Fv0.6%2Forg%2Fdid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692%2Finspect%2Fget-presentation-request%3FinspectorDid%3Ddid%3Avelocity%3A0xd4df29726d500f9b85bc6c7f1b3c021f16305692"

    static let DeepLink = VCLDeepLink(value: "velocity-network-devnet://inspect?request_uri=\(RequestUri)")

    static let QParams = "id=61efe084b2658481a3d9248c&vendorOriginContext=%7B%22SubjectKey%22%3A%7B%22BusinessUnit%22%3A%22ZC%22%22KeyCode%22%3A%2254514480%22%7D%22Token%22%3A%22832077a4%22%7D"

    static let  RequestUriWithQParams = "\(RequestUri)&\(QParams)"

    static let DeepLinkWithQParams = VCLDeepLink(value: "velocity-network-devnet://inspect?request_uri=\(RequestUriWithQParams)")

    static let PushDelegate = VCLPushDelegate(
        pushUrl: "https://devservices.velocitycareerlabs.io/api/push-gateway",
        pushToken: "if0123asd129smw321"
    )
}
