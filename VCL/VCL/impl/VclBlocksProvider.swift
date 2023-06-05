//
//  SdkBlocksProvider.swift
//  VCL
//
//  Created by Michael Avoyan on 19/03/2021.
//
// Copyright 2022 Velocity Career Labs inc.
// SPDX-License-Identifier: Apache-2.0

import Foundation

class VclBlocksProvider {
    
    private init(){}
    
    static func provideCountriesModel() -> CountriesModel {
        return CountriesModelImpl(
            CountriesUseCaseImpl(
                CountriesRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                ExecutorImpl()
            )
        )
    }
    
    static func provideCredentialTypeSchemasModel(credenctiialTypes: VCLCredentialTypes) -> CredentialTypeSchemasModel {
        return CredentialTypeSchemasModelImpl(
            CredentialTypeSchemasUseCaseImpl(
                CredentialTypeSchemaRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                credenctiialTypes,
                ExecutorImpl(),
                DispatcherImpl(),
                DsptchQueueImpl("CredentialTypeSchemas")
            )
        )
    }
    
    static func provideCredentialTypesModel() -> CredentialTypesModel {
        return CredentialTypesModelImpl(
            CredentialTypesUseCaseImpl(
                CredentialTypesRepositoryImpl(
                    NetworkServiceImpl(),
                    CacheServiceImpl()
                ),
                ExecutorImpl()
            )
        )
    }
    
    static func providePresentationRequestUseCase() -> PresentationRequestUseCase {
        return PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
//                JwtServiceVCLImpl(
//                    NetworkServiceImpl()
//                )
                JwtServiceImpl(KeyServiceImpl()) // ok
            ),
            ExecutorImpl()
        )
    }
    
    static func providePresentationSubmissionUseCase() -> PresentationSubmissionUseCase {
        return PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl())
            ),
            ExecutorImpl()
        )
    }
    
    static func provideOrganizationsUseCase() -> OrganizationsUseCase {
        return OrganizationsUseCaseImpl(
            OrganizationsRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideCredentialManifestUseCase() -> CredentialManifestUseCase {
        return CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl())
            ),
            ExecutorImpl()
        )
    }
    
    static func provideIdentificationUseCase() -> IdentificationSubmissionUseCase {
        return IdentificationSubmissionUseCaseImpl(
            IdentificationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl())
            ),
            ExecutorImpl()
        )
    }
    
    static func provideExchangeProgressUseCase() -> ExchangeProgressUseCase {
        return ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideGenerateOffersUseCase() -> GenerateOffersUseCase {
        return GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideFinalizeOffersUseCase() -> FinalizeOffersUseCase {
        return FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceImpl()),
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl())
            ),
            ExecutorImpl(),
            DispatcherImpl()
        )
    }
    
    static func provideCredentialTypesUIFormSchemaUseCase() -> CredentialTypesUIFormSchemaUseCase {
        return CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl(),
            DispatcherImpl()
        )
    }
    
    static func provideVerifiedProfileUseCase() -> VerifiedProfileUseCase {
        return VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                NetworkServiceImpl()
            ),
            ExecutorImpl()
        )
    }
    
    static func provideJwtServiceUseCase() -> JwtServiceUseCase {
        return JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                JwtServiceImpl(KeyServiceImpl())
            ),
            ExecutorImpl()
        )
    }
    
    static func provideKeyServiceUseCase() -> KeyServiceUseCase {
        return KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                KeyServiceImpl()
            ),
            ExecutorImpl()
        )
    }
}
