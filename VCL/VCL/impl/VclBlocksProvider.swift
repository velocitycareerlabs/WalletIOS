//
//  SdkBlocksProvider.swift
//  VCL
//
//  Created by Michael Avoyan on 19/03/2021.
//

import Foundation

class VclBlocksProvider {
    
    private init(){}
    
    static func provideCountriesModel() -> CountriesModel {
        return CountriesModelImpl(
            CountriesUseCaseImpl(
                CountriesRepositoryImpl(
                    NetworkServiceImpl()
                ),
                ExecutorImpl()
            )
        )
    }
    
    static func provideCredentialTypeSchemasModel(credenctiialTypes: VCLCredentialTypes) -> CredentialTypeSchemasModel {
        return CredentialTypeSchemasModelImpl(
            CredentialTypeSchemasUseCaseImpl(
                CredentialTypeSchemaRepositoryImpl(
                    NetworkServiceImpl()
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
                    NetworkServiceImpl()
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
                JwtServiceMicrosoftImpl() // ok
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
//                JwtServiceVCLImpl(
//                    NetworkServiceImpl()
//                )
                JwtServiceMicrosoftImpl()
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
//                JwtServiceVCLImpl(
//                    NetworkServiceImpl()
//                )
                JwtServiceMicrosoftImpl() // ok
            ),
            ExecutorImpl()
        )
    }
    
//    static func provideIdentificationModel() -> IdentificationModel {
//        return IdentificationModelImpl(
//            identificationSubmissionUseCase: IdentificationSubmissionUseCaseImpl(
//                IdentificationSubmissionRepositoryImpl(
//                    NetworkServiceImpl()
//                ),
//                JwtServiceRepositoryImpl(
////                JwtServiceVCLImpl(
////                    NetworkServiceImpl()
////                )
//                    JwtServiceMicrosoftImpl()
//                ),
//                ExecutorImpl()
//            )
//        )
//    }
    
    static func provideIdentificationUseCase() -> IdentificationSubmissionUseCase {
        return IdentificationSubmissionUseCaseImpl(
            IdentificationSubmissionRepositoryImpl(
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
//                JwtServiceVCLImpl(
//                    NetworkServiceImpl()
//                )
                JwtServiceMicrosoftImpl()
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
                NetworkServiceImpl()
            ),
            JwtServiceRepositoryImpl(
//                JwtServiceVCLImpl(
//                    NetworkServiceImpl()
//                )
                JwtServiceMicrosoftImpl()
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
                JwtServiceMicrosoftImpl()
            ),
            ExecutorImpl()
        )
    }
}
