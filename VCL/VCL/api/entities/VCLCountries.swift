//
//  VCLCountries.swift
//  VCL
//
//  Created by Michael Avoyan on 09/12/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

public struct VCLCountries {
    public let all: [VCLCountry]?
    
    public init(all: [VCLCountry]?) {
        self.all = all
    }
    
    public func countryByCode(code: String) -> VCLCountry? {
        countryBy(key: VCLCountry.Codes.KeyCode, value: code)
    }
    
    private func countryBy(key: String, value: String) -> VCLCountry? {
        all?.first { country in country.payload[key] as! String == value }
    }
    
    public enum Codes {
        public static let BD: String = "BD"
        public static let BE: String = "BE"
        public static let BF: String = "BF"
        public static let BG: String = "BG"
        public static let BA: String = "BA"
        public static let BB: String = "BB"
        public static let WF: String = "WF"
        public static let BL: String = "BL"
        public static let BM: String = "BM"
        public static let BN: String = "BN"
        public static let BO: String = "BO"
        public static let BH: String = "BH"
        public static let BI: String = "BI"
        public static let BJ: String = "BJ"
        public static let BT: String = "BT"
        public static let JM: String = "JM"
        public static let BV: String = "BV"
        public static let BW: String = "BW"
        public static let WS: String = "WS"
        public static let BQ: String = "BQ"
        public static let BR: String = "BR"
        public static let BS: String = "BS"
        public static let JE: String = "JE"
        public static let BY: String = "BY"
        public static let BZ: String = "BZ"
        public static let RU: String = "RU"
        public static let RW: String = "RW"
        public static let RS: String = "RS"
        public static let TL: String = "TL"
        public static let RE: String = "RE"
        public static let TM: String = "TM"
        public static let TJ: String = "TJ"
        public static let RO: String = "RO"
        public static let TK: String = "TK"
        public static let GW: String = "GW"
        public static let GU: String = "GU"
        public static let GT: String = "GT"
        public static let GS: String = "GS"
        public static let GR: String = "GR"
        public static let GQ: String = "GQ"
        public static let GP: String = "GP"
        public static let JP: String = "JP"
        public static let GY: String = "GY"
        public static let GG: String = "GG"
        public static let GF: String = "GF"
        public static let GE: String = "GE"
        public static let GD: String = "GD"
        public static let GB: String = "GB"
        public static let GA: String = "GA"
        public static let SV: String = "SV"
        public static let GN: String = "GN"
        public static let GM: String = "GM"
        public static let GL: String = "GL"
        public static let GI: String = "GI"
        public static let GH: String = "GH"
        public static let OM: String = "OM"
        public static let TN: String = "TN"
        public static let JO: String = "JO"
        public static let HR: String = "HR"
        public static let HT: String = "HT"
        public static let HU: String = "HU"
        public static let HK: String = "HK"
        public static let HN: String = "HN"
        public static let HM: String = "HM"
        public static let VE: String = "VE"
        public static let PR: String = "PR"
        public static let PS: String = "PS"
        public static let PW: String = "PW"
        public static let PT: String = "PT"
        public static let SJ: String = "SJ"
        public static let PY: String = "PY"
        public static let IQ: String = "IQ"
        public static let PA: String = "PA"
        public static let PF: String = "PF"
        public static let PG: String = "PG"
        public static let PE: String = "PE"
        public static let PK: String = "PK"
        public static let PH: String = "PH"
        public static let PN: String = "PN"
        public static let PL: String = "PL"
        public static let PM: String = "PM"
        public static let ZM: String = "ZM"
        public static let EH: String = "EH"
        public static let EE: String = "EE"
        public static let EG: String = "EG"
        public static let ZA: String = "ZA"
        public static let EC: String = "EC"
        public static let IT: String = "IT"
        public static let VN: String = "VN"
        public static let SB: String = "SB"
        public static let ET: String = "ET"
        public static let SO: String = "SO"
        public static let ZW: String = "ZW"
        public static let SA: String = "SA"
        public static let ES: String = "ES"
        public static let ER: String = "ER"
        public static let ME: String = "ME"
        public static let MD: String = "MD"
        public static let MG: String = "MG"
        public static let MF: String = "MF"
        public static let MA: String = "MA"
        public static let MC: String = "MC"
        public static let UZ: String = "UZ"
        public static let MM: String = "MM"
        public static let ML: String = "ML"
        public static let MO: String = "MO"
        public static let MN: String = "MN"
        public static let MH: String = "MH"
        public static let MK: String = "MK"
        public static let MU: String = "MU"
        public static let MT: String = "MT"
        public static let MW: String = "MW"
        public static let MV: String = "MV"
        public static let MQ: String = "MQ"
        public static let MP: String = "MP"
        public static let MS: String = "MS"
        public static let MR: String = "MR"
        public static let IM: String = "IM"
        public static let UG: String = "UG"
        public static let TZ: String = "TZ"
        public static let MY: String = "NY"
        public static let MX: String = "MX"
        public static let IL: String = "IL"
        public static let FR: String = "FR"
        public static let IO: String = "IO"
        public static let SH: String = "SH"
        public static let FI: String = "FI"
        public static let FJ: String = "FJ"
        public static let FK: String = "FK"
        public static let FM: String = "FM"
        public static let FO: String = "FO"
        public static let NI: String = "NI"
        public static let NL: String = "NL"
        public static let NO: String = "NO"
        public static let NA: String = "NA"
        public static let VU: String = "VU"
        public static let NC: String = "NC"
        public static let NE: String = "NE"
        public static let NF: String = "NF"
        public static let NG: String = "NG"
        public static let NZ: String = "NZ"
        public static let NP: String = "NP"
        public static let NR: String = "NR"
        public static let NU: String = "NU"
        public static let CK: String = "CK"
        public static let XK: String = "XK"
        public static let CI: String = "CI"
        public static let CH: String = "CH"
        public static let CO: String = "CO"
        public static let CN: String = "CN"
        public static let CM: String = "CM"
        public static let CL: String = "CL"
        public static let CC: String = "CC"
        public static let CA: String = "CA"
        public static let CG: String = "CG"
        public static let CF: String = "CF"
        public static let CD: String = "CD"
        public static let CZ: String = "CZ"
        public static let CY: String = "CY"
        public static let CX: String = "CX"
        public static let CR: String = "CR"
        public static let CW: String = "CW"
        public static let CV: String = "CV"
        public static let CU: String = "CU"
        public static let SZ: String = "SZ"
        public static let SY: String = "SY"
        public static let SX: String = "SX"
        public static let KG: String = "KG"
        public static let KE: String = "KE"
        public static let SS: String = "SS"
        public static let SR: String = "SR"
        public static let KI: String = "KI"
        public static let KH: String = "KH"
        public static let KN: String = "KN"
        public static let KM: String = "KM"
        public static let ST: String = "ST"
        public static let SK: String = "SK"
        public static let KR: String = "KR"
        public static let SI: String = "SI"
        public static let KP: String = "KP"
        public static let KW: String = "KW"
        public static let SN: String = "SN"
        public static let SM: String = "SM"
        public static let SL: String = "SL"
        public static let SC: String = "SC"
        public static let KZ: String = "KZ"
        public static let KY: String = "KY"
        public static let SG: String = "SG"
        public static let SE: String = "SE"
        public static let SD: String = "SD"
        public static let DO: String = "DO"
        public static let DM: String = "DM"
        public static let DJ: String = "DJ"
        public static let DK: String = "DK"
        public static let VG: String = "VG"
        public static let DE: String = "DE"
        public static let YE: String = "YE"
        public static let DZ: String = "DZ"
        public static let US: String = "US"
        public static let UY: String = "UY"
        public static let YT: String = "YT"
        public static let UM: String = "UM"
        public static let LB: String = "LB"
        public static let LC: String = "LC"
        public static let LA: String = "LA"
        public static let TV: String = "TV"
        public static let TW: String = "TW"
        public static let TT: String = "TT"
        public static let TR: String = "TR"
        public static let LK: String = "LK"
        public static let LI: String = "LI"
        public static let LV: String = "LV"
        public static let TO: String = "TO"
        public static let LT: String = "LT"
        public static let LU: String = "LU"
        public static let LR: String = "LR"
        public static let LS: String = "LS"
        public static let TH: String = "TH"
        public static let TF: String = "TF"
        public static let TG: String = "TG"
        public static let TD: String = "TD"
        public static let TC: String = "TC"
        public static let LY: String = "LY"
        public static let VA: String = "VA"
        public static let VC: String = "VC"
        public static let AE: String = "AE"
        public static let AD: String = "AD"
        public static let AG: String = "AG"
        public static let AF: String = "AF"
        public static let AI: String = "AI"
        public static let VI: String = "VI"
        public static let IS: String = "IS"
        public static let IR: String = "IR"
        public static let AM: String = "AM"
        public static let AL: String = "AL"
        public static let AO: String = "AO"
        public static let AQ: String = "AQ"
        public static let AS: String = "AS"
        public static let AR: String = "AR"
        public static let AU: String = "AU"
        public static let AT: String = "AT"
        public static let AW: String = "AW"
        public static let IN: String = "IN"
        public static let AX: String = "AX"
        public static let AZ: String = "AZ"
        public static let IE: String = "IE"
        public static let ID: String = "ID"
        public static let UA: String = "UA"
        public static let QA: String = "QA"
        public static let MZ: String = "MZ"
        public static let UK: String = "UK"
    }
}
