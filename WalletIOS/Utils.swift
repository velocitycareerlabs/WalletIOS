//
//  Utils.swift
//  WalletIOS
//
//  Created by Michael Avoyan on 18/07/2021.
//

import Foundation
import VCL

class Utils {
    static func getApprovedRejectedOfferIdsMock(offers: VCLOffers) -> ([String], [String]) {
        var approvedOfferIds = [String]()
        var rejectedOfferIds = [String]()
        var offer1: String? = nil
        var offer2: String? = nil
        if(offers.all.count > 0) {
            offer1 = ((offers.all[0])["id"]) as? String ?? ""
        }
        if(offers.all.count > 1) {
            offer2 = ((offers.all[1])["id"]) as? String ?? ""
        }
        approvedOfferIds = [offer1].compactMap{ $0 }
        rejectedOfferIds = [offer2].compactMap{ $0 }
        return (approvedOfferIds, rejectedOfferIds)
    }
}
