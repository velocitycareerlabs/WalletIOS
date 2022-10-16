//
//  CredentialTypeSchemaMocks.swift
//  VCLTests
//
//  Created by Michael Avoyan on 03/05/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation
@testable import VCL

class CredentialTypeSchemaMocks {
        static let CredentialTypeSchemaJson = "{\n" +
                "  \"title\": \"vaccination-certificate\",\n" +
                "  \"id\": \"https://velocitynetwork.foundation/schemas/vaccination-certificate\",\n" +
                "  \"type\": \"object\",\n" +
                "  \"properties\": {\n" +
                "    \"disease\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"description\": \"Disease or agent that the vaccination provides protection against\"\n" +
                "    },\n" +
                "    \"vaccineDescription\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"description\": \"Generic description of the vaccine/prophylaxis\"\n" +
                "    },\n" +
                "    \"vaccineType\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"description\": \"Generic description of the vaccine/prophylaxis or its component(s) [J07BX03 covid-19 vaccines]\"\n" +
                "    },\n" +
                "    \"certifiedBy\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"description\": \"Entity that has issued the certificate (allowing to check the certificate)\"\n" +
                "    },\n" +
                "    \"certificateNumber\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"description\": \"Unique identifier of the certificate (UVCI), to be printed (human readable) into the certificate; the unique identifier can be included in the IIS\"\n" +
                "    },\n" +
                "    \"certificateValidFrom\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"format\": \"date-time\",\n" +
                "      \"description\": \"Certificate valid from (required if known)\"\n" +
                "    },\n" +
                "    \"certificateValidTo\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"format\": \"date-time\",\n" +
                "      \"description\": \"Certificate valid until (validity can differ from the expected immunisation period)\"\n" +
                "    },\n" +
                "    \"formVersion\": {\n" +
                "      \"type\": \"string\",\n" +
                "      \"pattern\": \"^1.0.0\",\n" +
                "      \"description\": \"Version of this minimum dataset definition\"\n" +
                "    }\n" +
                "  },\n" +
                "  \"required\": [\n" +
                "    \"disease\",\n" +
                "    \"vaccineDescription\",\n" +
                "    \"vaccineType\",\n" +
                "    \"certifiedBy\",\n" +
                "    \"certificateNumber\",\n" +
                "    \"certificateValidFrom\",\n" +
                "    \"formVersion\"\n" +
                "  ]}\n"

        static let CredentialType = VCLCredentialType(
            payload: [String: Any](),
            id: "60759e68c4a22d1aea4820a5",
            schema: "???",
            createdAt: "2021-04-13T13:36:40.832Z",
            schemaName: "vaccination-certificate-apr-2021",
            credentialType: "VaccinationCertificate-Apr2021"
        )

        static let CredentialTypes = VCLCredentialTypes(
            all: [CredentialType]
        )
}
