//
//  CountriesMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 02/05/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class CountriesMocks {
    
    static let AfghanistanRegion1Name = "Balkh Province"
    static let AfghanistanRegion1Code = "BAL"
    static let AfghanistanRegion2Name = "Bamyan Province"
    static let AfghanistanRegion2Code = "BAM"
    static let AfghanistanRegion3Name = "Badghis Province"
    static let AfghanistanRegion3Code = "BDG"

    static let AfghanistanRegion1 = "{\"name\":\"Balkh Province\",\"code\":\"BAL\"}"
    static let AfghanistanRegion2 = "{\"name\":\"Bamyan Province\",\"code\":\"BAM\"}"
    static let AfghanistanRegion3 = "{\"name\":\"Badghis Province\",\"code\":\"BDG\"}"
    static let AfghanistanRegions =
        "[\(AfghanistanRegion1),\(AfghanistanRegion2),\(AfghanistanRegion3),{\"name\":\"Badakhshan Province\",\"code\":\"BDS\"},{\"name\":\"Baghlan Province\",\"code\":\"BGL\"},{\"name\":\"Daykundi Province\",\"code\":\"DAY\"},{\"name\":\"Farah Province\",\"code\":\"FRA\"},{\"name\":\"Faryab Province\",\"code\":\"FYB\"},{\"name\":\"Ghazni Province\",\"code\":\"GHA\"},{\"name\":\"Ghōr Province\",\"code\":\"GHO\"},{\"name\":\"Helmand Province\",\"code\":\"HEL\"},{\"name\":\"Herat Province\",\"code\":\"HER\"},{\"name\":\"Jowzjan Province\",\"code\":\"JOW\"},{\"name\":\"Kabul Province\",\"code\":\"KAB\"},{\"name\":\"Kandahar Province\",\"code\":\"KAN\"},{\"name\":\"Kapisa Province\",\"code\":\"KAP\"},{\"name\":\"Kunduz Province\",\"code\":\"KDZ\"},{\"name\":\"Khost Province\",\"code\":\"KHO\"},{\"name\":\"Kunar Province\",\"code\":\"KNR\"},{\"name\":\"Laghman Province\",\"code\":\"LAG\"},{\"name\":\"Logar Province\",\"code\":\"LOG\"},{\"name\":\"Nangarhar Province\",\"code\":\"NAN\"},{\"name\":\"Nimruz Province\",\"code\":\"NIM\"},{\"name\":\"Nuristan Province\",\"code\":\"NUR\"},{\"name\":\"Oruzgan\",\"code\":\"ORU\"},{\"name\":\"Panjshir Province\",\"code\":\"PAN\"},{\"name\":\"Parwan Province\",\"code\":\"PAR\"},{\"name\":\"Paktia Province\",\"code\":\"PIA\"},{\"name\":\"Paktika Province\",\"code\":\"PKA\"},{\"name\":\"Samangan Province\",\"code\":\"SAM\"},{\"name\":\"Sar-e Pol Province\",\"code\":\"SAR\"},{\"name\":\"Takhar Province\",\"code\":\"TAK\"},{\"name\":\"Urozgan Province\",\"code\":\"URU\"},{\"name\":\"Maidan Wardak Province\",\"code\":\"WAR\"},{\"name\":\"Zabul Province\",\"code\":\"ZAB\"}]"
    static let AfghanistanName = "Afghanistan"
    static let AfghanistanCode = "AF"
    static let AfghanistanCountry =
        "{\"name\":\"\(AfghanistanName)\",\"code\":\"\(AfghanistanCode)\",\"regions\":\(AfghanistanRegions)}"

    static let CountriesJson =
        "[\(AfghanistanCountry),{\"name\":\"South Sudan\",\"code\":\"SS\",\"regions\":[{\"name\":\"Ruweng\",\"code\":\"\"},{\"name\":\"Maiwut\",\"code\":\"\"},{\"name\":\"Akobo\",\"code\":\"\"},{\"name\":\"Aweil\",\"code\":\"\"},{\"name\":\"Eastern Lakes\",\"code\":\"\"},{\"name\":\"Gogrial\",\"code\":\"\"},{\"name\":\"Lol\",\"code\":\"\"},{\"name\":\"Amadi State\",\"code\":\"\"},{\"name\":\"Yei River\",\"code\":\"\"},{\"name\":\"Fashoda\",\"code\":\"\"},{\"name\":\"Gok\",\"code\":\"\"},{\"name\":\"Tonj\",\"code\":\"\"},{\"name\":\"Twic\",\"code\":\"\"},{\"name\":\"Wau\",\"code\":\"\"},{\"name\":\"Gbudwe\",\"code\":\"\"},{\"name\":\"Imatong\",\"code\":\"\"},{\"name\":\"Jubek\",\"code\":\"\"},{\"name\":\"Maridi\",\"code\":\"\"},{\"name\":\"Terekeka\",\"code\":\"\"},{\"name\":\"Boma\",\"code\":\"\"},{\"name\":\"Bieh\",\"code\":\"\"},{\"name\":\"Central Upper Nile\",\"code\":\"\"},{\"name\":\"Latjoor\",\"code\":\"\"},{\"name\":\"Northern Liech\",\"code\":\"\"},{\"name\":\"Southern Liech\",\"code\":\"\"},{\"name\":\"Fangak\",\"code\":\"\"},{\"name\":\"Western Lakes\",\"code\":\"\"},{\"name\":\"Aweil East\",\"code\":\"\"},{\"name\":\"Northern Upper Nile\",\"code\":\"\"},{\"name\":\"Tambura\",\"code\":\"\"},{\"name\":\"Kapoeta\",\"code\":\"\"},{\"name\":\"Jonglei\",\"code\":\"JG\"}]},{\"name\":\"Kosovo\",\"code\":\"XK\",\"regions\":[]}]"
}
