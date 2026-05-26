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
    
    static func chooseKeyService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> VCLKeyService {
        switch (cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLKeyServiceLocalImpl()
            
        case VCLCryptoServiceType.Remote:
            if let keyServiceUrls = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.keyServiceUrls {
                return VCLKeyServiceRemoteImpl(
                    networkServiceFactory(),
                    keyServiceUrls
                )
            } else {
                throw VCLError(errorCode: VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
            }
            
        case VCLCryptoServiceType.Injected:
            if let keyService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.keyService {
                return keyService
            } else {
                throw VCLError(errorCode: VCLErrorCode.InjectedServicesNotFount.rawValue)
            }
        }
    }
    
    static func chooseJwtSignService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> VCLJwtSignService {
        switch (cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLJwtSignServiceLocalImpl(
                try chooseKeyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            )
            
        case VCLCryptoServiceType.Remote:
            if let jwtSignServiceUrl = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.jwtServiceUrls.jwtSignServiceUrl {
                return VCLJwtSignServiceRemoteImpl(
                    networkServiceFactory(),
                    jwtSignServiceUrl
                )
            } else {
                throw VCLError(errorCode: VCLErrorCode.RemoteServicesUrlsNotFount.rawValue)
            }
            
        case VCLCryptoServiceType.Injected:
            if let jwtSignService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.jwtSignService {
                return jwtSignService
            } else {
                throw VCLError(errorCode: VCLErrorCode.InjectedServicesNotFount.rawValue)
            }
        }
    }
    
    static func chooseJwtVerifyService(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> VCLJwtVerifyService {
        switch (cryptoServicesDescriptor.cryptoServiceType) {
        case VCLCryptoServiceType.Local:
            return VCLJwtVerifyServiceLocalImpl()
            
        case VCLCryptoServiceType.Remote:
            if let jwtVerifyServiceUrl = cryptoServicesDescriptor.remoteCryptoServicesUrlsDescriptor?.jwtServiceUrls.jwtVerifyServiceUrl {
                return VCLJwtVerifyServiceRemoteImpl(
                    networkServiceFactory(),
                    jwtVerifyServiceUrl
                )
            } else {
                return VCLJwtVerifyServiceLocalImpl() // verification may be done locally
            }
            
        case VCLCryptoServiceType.Injected:
            if let jwtVerifyService = cryptoServicesDescriptor.injectedCryptoServicesDescriptor?.jwtVerifyService {
                return jwtVerifyService
            } else {
                return VCLJwtVerifyServiceLocalImpl() // verification may be done locally
            }
        }
    }
    
    static func provideCountriesModel(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> CountriesModel {
        return CountriesModelImpl(
            CountriesUseCaseImpl(
                CountriesRepositoryImpl(
                    networkServiceFactory(),
                    CacheServiceImpl()
                ),
                ExecutorImpl.instance
            )
        )
    }
    
    static func provideCredentialTypeSchemasModel(
        credenctiialTypes: VCLCredentialTypes,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> CredentialTypeSchemasModel {
        return CredentialTypeSchemasModelImpl(
            CredentialTypeSchemasUseCaseImpl(
                CredentialTypeSchemaRepositoryImpl(
                    networkServiceFactory(),
                    CacheServiceImpl()
                ),
                credenctiialTypes,
                ExecutorImpl.instance,
                DispatcherImpl()
            )
        )
    }
    
    static func provideCredentialTypesModel(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> CredentialTypesModel {
        return CredentialTypesModelImpl(
            CredentialTypesUseCaseImpl(
                CredentialTypesRepositoryImpl(
                    networkServiceFactory(),
                    CacheServiceImpl()
                ),
                ExecutorImpl.instance
            )
        )
    }
    
    static func providePresentationRequestUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> PresentationRequestUseCase {
        return PresentationRequestUseCaseImpl(
            PresentationRequestRepositoryImpl(
                networkServiceFactory()
            ),
            ResolveDidDocumentRepositoryImpl(
                networkServiceFactory()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                ),
                try chooseJwtVerifyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            PresentationRequestByDeepLinkVerifierImpl(),
            ExecutorImpl.instance
        )
    }
    
    static func providePresentationSubmissionUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> PresentationSubmissionUseCase {
        return PresentationSubmissionUseCaseImpl(
            PresentationSubmissionRepositoryImpl(
                networkServiceFactory()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                ),
                try chooseJwtVerifyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideOrganizationsUseCase(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> OrganizationsUseCase {
        return OrganizationsUseCaseImpl(
            OrganizationsRepositoryImpl(
                networkServiceFactory()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideCredentialManifestUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> CredentialManifestUseCase {
        return CredentialManifestUseCaseImpl(
            CredentialManifestRepositoryImpl(
                networkServiceFactory()
            ),
            ResolveDidDocumentRepositoryImpl(
                networkServiceFactory()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                ),
                try chooseJwtVerifyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            CredentialManifestByDeepLinkVerifierImpl(),
            ExecutorImpl.instance
        )
    }
    
    static func provideIdentificationSubmissionUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> IdentificationSubmissionUseCase {
        return IdentificationSubmissionUseCaseImpl(
            IdentificationSubmissionRepositoryImpl(
                networkServiceFactory()
            ),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                ),
                try chooseJwtVerifyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideExchangeProgressUseCase(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> ExchangeProgressUseCase {
        return ExchangeProgressUseCaseImpl(
            ExchangeProgressRepositoryImpl(
                networkServiceFactory()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideGenerateOffersUseCase(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> GenerateOffersUseCase {
        return GenerateOffersUseCaseImpl(
            GenerateOffersRepositoryImpl(
                networkServiceFactory()
            ),
            OffersByDeepLinkVerifierImpl(
                ResolveDidDocumentRepositoryImpl(
                    networkServiceFactory()
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideFinalizeOffersUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        _ credentialTypesModel: CredentialTypesModel,
        _ isDirectIssuerCheckOn: Bool,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> FinalizeOffersUseCase {
        var credentialIssuerVerifier: CredentialIssuerVerifier = CredentialIssuerVerifierEmptyImpl()
        if (isDirectIssuerCheckOn) {
            credentialIssuerVerifier = CredentialIssuerVerifierImpl(
                credentialTypesModel,
                CredentialSubjectContextRepositoryImpl(
                    networkServiceFactory()
                )
            )
        }
        return FinalizeOffersUseCaseImpl(
            FinalizeOffersRepositoryImpl(
                networkServiceFactory()),
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                ),
                try chooseJwtVerifyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            credentialIssuerVerifier,
            CredentialDidVerifierImpl(),
            CredentialsByDeepLinkVerifierImpl(
                ResolveDidDocumentRepositoryImpl(
                    networkServiceFactory()
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideAuthTokenUseCase(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> AuthTokenUseCase {
        return AuthTokenUseCaseImpl(
            AuthTokenRepositoryImpl(
                networkServiceFactory()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideCredentialTypesUIFormSchemaUseCase(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> CredentialTypesUIFormSchemaUseCase {
        return CredentialTypesUIFormSchemaUseCaseImpl(
            CredentialTypesUIFormSchemaRepositoryImpl(
                networkServiceFactory()
            ),
            ExecutorImpl.instance,
            DispatcherImpl()
        )
    }
    
    static func provideVerifiedProfileUseCase(
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) -> VerifiedProfileUseCase {
        return VerifiedProfileUseCaseImpl(
            VerifiedProfileRepositoryImpl(
                networkServiceFactory()
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideJwtServiceUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> JwtServiceUseCase {
        return JwtServiceUseCaseImpl(
            JwtServiceRepositoryImpl(
                try chooseJwtSignService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                ),
                try chooseJwtVerifyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            ExecutorImpl.instance
        )
    }
    
    static func provideKeyServiceUseCase(
        _ cryptoServicesDescriptor: VCLCryptoServicesDescriptor,
        networkServiceFactory: @escaping () -> NetworkService = { NetworkServiceImpl() }
    ) throws -> KeyServiceUseCase {
        return KeyServiceUseCaseImpl(
            KeyServiceRepositoryImpl(
                try chooseKeyService(
                    cryptoServicesDescriptor,
                    networkServiceFactory: networkServiceFactory
                )
            ),
            ExecutorImpl.instance
        )
    }
}
