//
//  SdkBlocksProvider.swift
//  VCL
//
//  Created by Michael Avoyan on 19/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import Foundation

class VclBlocksProvider {
    
    private init(){}
    
    private static func chooseJwtService(
        _ keyServiceType: VCLKeyServiceType
    ) -> JwtService {
        if keyServiceType == .REMOTE {
            return JwtServiceRemoteImpl(NetworkServiceImpl())
        }
        return JwtServiceImpl(KeyServiceImpl())
    }
    
    private static func chooseKeyService(
        _ keyServiceType: VCLKeyServiceType
    ) -> KeyService {
        if keyServiceType == .REMOTE {
            return KeyServiceRemoteImpl(NetworkServiceImpl())
        }
        return KeyServiceImpl()
    }
    
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
    
    static func providePresentationRequestUseCase(
        _ keyServiceType: VCLKeyServiceType
    ) -> PresentationRequestUseCase {
        return PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                chooseJwtService(keyServiceType)
            ),
            ExecutorImpl()
        )
    }
    
    static func providePresentationSubmissionUseCase(
        _ keyServiceType: VCLKeyServiceType
) -> PresentationSubmissionUseCase {
        return PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                chooseJwtService(keyServiceType)
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
    
    static func provideCredentialManifestUseCase(
        _ keyServiceType: VCLKeyServiceType
    ) -> CredentialManifestUseCase {
        return CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                NetworkServiceImpl()
            ),
            ResolveKidRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                chooseJwtService(keyServiceType)
            ),
            ExecutorImpl()
        )
    }
    
    static func provideIdentificationSubmissionUseCase(
        _ keyServiceType: VCLKeyServiceType
    ) -> IdentificationSubmissionUseCase {
        return IdentificationSubmissionUseCaseImpl(
            IdentificationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
                chooseJwtService(keyServiceType)
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
    
    static func provideFinalizeOffersUseCase(
        _ keyServiceType: VCLKeyServiceType,
        _ credentialTypesModel: CredentialTypesModel
    ) -> FinalizeOffersUseCase {
        return FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                NetworkServiceImpl()),
            JwtServiceRepositoryImpl(
                chooseJwtService(keyServiceType)
            ),
            CredentialIssuerVerifierImpl(
                credentialTypesModel,
                NetworkServiceImpl()
            ),
            CredentialDidVerifierImpl(),
            ExecutorImpl()
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
    
    static func provideJwtServiceUseCase(
        _ keyServiceType: VCLKeyServiceType
    ) -> JwtServiceUseCase {
        return JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                chooseJwtService(keyServiceType)
            ),
            ExecutorImpl()
        )
    }
    
    static func provideKeyServiceUseCase(
        _ keyServiceType: VCLKeyServiceType
    ) -> KeyServiceUseCase {
        return KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                chooseKeyService(keyServiceType)
            ),
            ExecutorImpl()
        )
    }
}
