//
//  CredentialTypesUIFormSchemaMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 14/06/2021.
//

import Foundation

class CredentialTypesUIFormSchemaMocks {
    static let CountriesJson =
        "[{ \"name\":\"Canada\", \"code\":\"CA\", \"regions\":[ { \"name\":\"Alberta\", \"code\":\"AB\" }, { \"name\":\"British Columbia\", \"code\":\"BC\" }, { \"name\":\"Manitoba\", \"code\":\"MB\" }, { \"name\":\"New Brunswick\", \"code\":\"NB\" }, { \"name\":\"Newfoundland and Labrador\", \"code\":\"NL\" }, { \"name\":\"Nova Scotia\", \"code\":\"NS\" }, { \"name\":\"Northwest Territories\", \"code\":\"NT\" }, { \"name\":\"Nunavut\", \"code\":\"NU\" }, { \"name\":\"Ontario\", \"code\":\"ON\" }, { \"name\":\"Prince Edward Island\", \"code\":\"PE\" }, { \"name\":\"Quebec\", \"code\":\"QC\" }, { \"name\":\"Saskatchewan\", \"code\":\"SK\" }, { \"name\":\"Yukon\", \"code\":\"YT\" } ] }]"
    static let CountryCodes = "[\"CA\"]"
    static let CountryNames = "[\"Canada\"]"
    static let CanadaRegionCodes =
        "[\"AB\",\"BC\",\"MB\",\"NB\",\"NL\",\"NS\",\"NT\",\"NU\",\"ON\",\"PE\",\"QC\",\"SK\",\"YT\"]"
    static let CanadaRegionNames =
        "[\"Alberta\",\"British Columbia\",\"Manitoba\",\"New Brunswick\",\"Newfoundland and Labrador\",\"Nova Scotia\",\"Northwest Territories\",\"Nunavut\",\"Ontario\",\"Prince Edward Island\",\"Quebec\",\"Saskatchewan\",\"Yukon\"]"

    static let UISchemaFormJsonFull = "{ \"name\": { \"ui.title\": \"Issued by\" }, \"identifer\": { \"ui.widget\": \"hidden\" }, \"place\": { \"name\": { \"ui.widget\": \"hidden\" }, \"addressCountry\": { \"ui.title\": \"Country\", \"ui:enum\": [ \"TARGET_COUNTRIES_ENUM\" ], \"ui:enumNames\": [ \"TARGET_COUNTRIES_ENUM_NAMES\" ], \"ui:widget\": \"select\" }, \"addressRegion\": { \"ui.title\": \"State or region\", \"ui:enum\": [\"TARGET_REGIONS_ENUM\"], \"ui:enumNames\": [\"TARGET_REGIONS_ENUM_NAMES\"], \"ui:widget\": \"select\" }, \"addressLocality\": { \"ui.widget\": \"hidden\" } }, \"ui:order\": [ \"name\", \"place\" ] }"
    static let UISchemaFormJsonOnlyCountries = "{ \"name\": { \"ui.title\": \"Issued by\" }, \"identifer\": { \"ui.widget\": \"hidden\" }, \"place\": { \"name\": { \"ui.widget\": \"hidden\" }, \"addressCountry\": { \"ui.title\": \"Country\", \"ui:enum\": [ \"TARGET_COUNTRIES_ENUM\" ], \"ui:enumNames\": [ \"TARGET_COUNTRIES_ENUM_NAMES\" ], \"ui:widget\": \"select\" }, \"addressRegion\": { \"ui:widget\": \"hidden\" }, \"addressLocality\": { \"ui.widget\": \"hidden\" } }, \"ui:order\": [ \"name\", \"place\" ] }"
    static let UISchemaFormJsonOnlyRegions = "{ \"name\": { \"ui.title\": \"Issued by\" }, \"identifer\": { \"ui.widget\": \"hidden\" }, \"place\": { \"name\": { \"ui.widget\": \"hidden\" }, \"addressCountry\": { \"ui.title\": \"Country\", \"ui:widget\": \"select\" }, \"addressRegion\": { \"ui.title\": \"State or region\", \"ui:enum\": [\"TARGET_REGIONS_ENUM\"], \"ui:enumNames\": [\"TARGET_REGIONS_ENUM_NAMES\"], \"ui:widget\": \"select\" }, \"addressLocality\": { \"ui.widget\": \"hidden\" } }, \"ui:order\": [ \"name\", \"place\" ] }"
    static let UISchemaFormJsonOnlyEnums = "{ \"name\": { \"ui.title\": \"Issued by\" }, \"identifer\": { \"ui.widget\": \"hidden\" }, \"place\": { \"name\": { \"ui.widget\": \"hidden\" }, \"addressCountry\": { \"ui.title\": \"Country\", \"ui:enum\": [ \"TARGET_COUNTRIES_ENUM\" ], \"ui:widget\": \"select\" }, \"addressRegion\": { \"ui.title\": \"State or region\", \"ui:enum\": [\"TARGET_REGIONS_ENUM\"], \"ui:widget\": \"select\" }, \"addressLocality\": { \"ui.widget\": \"hidden\" } }, \"ui:order\": [ \"name\", \"place\" ] }"
}
