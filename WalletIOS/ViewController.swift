//
//  ViewController.swift
//  WalletIOS
//
//  Created by Michael Avoyan on 16/03/2021.
//
//  Copyright 2022 Velocity Career Labs inc.
//  SPDX-License-Identifier: Apache-2.0

import UIKit
import VCL

class ViewController: UIViewController {
    
    @IBOutlet weak var controlsView: UIView!
    @IBOutlet weak var disclosingCredentialsBtn: UIButton!
    @IBOutlet weak var receivingCredentialsByDeepLinkBtn: UIButton!
    @IBOutlet weak var receivingCredentialsByServicesBtn: UIButton!
    @IBOutlet weak var selfReportingCredentialsBtn: UIButton!
    @IBOutlet weak var refreshCredentialsBtn: UIButton!
    @IBOutlet weak var verifiedProfileBtn: UIButton!
    @IBOutlet weak var verifyJwtBtn: UIButton!
    @IBOutlet weak var generateSignedJwtBtn: UIButton!
    @IBOutlet weak var generateDidJwkBtn: UIButton!
    @IBOutlet weak var errorView: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    private let environment = VCLEnvironment.Dev
    private let vcl = VCLProvider.vclInstance()
    private var didJwk: VCLDidJwk? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        disclosingCredentialsBtn.addTarget(self, action: #selector(getPresentationRequest), for: .touchUpInside)
        receivingCredentialsByDeepLinkBtn.addTarget(self, action: #selector(getCredentialManifestByDeepLink), for: .touchUpInside)
        receivingCredentialsByServicesBtn.addTarget(self, action: #selector(getOrganizationsThenCredentialManifestByService), for: .touchUpInside)
        selfReportingCredentialsBtn.addTarget(self, action: #selector(getCredentialTypesUIFormSchema), for: .touchUpInside)
        refreshCredentialsBtn.addTarget(self, action: #selector(refreshCredentials), for: .touchUpInside)
        verifiedProfileBtn.addTarget(self, action: #selector(getVerifiedProfile), for: .touchUpInside)
        verifyJwtBtn.addTarget(self, action: #selector(verifyJwt), for: .touchUpInside)
        generateSignedJwtBtn.addTarget(self, action: #selector(generateSignedJwt), for: .touchUpInside)
        generateDidJwkBtn.addTarget(self, action: #selector(generateDidJwk), for: .touchUpInside)
        
        vcl.initialize(
            initializationDescriptor: VCLInitializationDescriptor(
                environment: environment,
                xVnfProtocolVersion: .XVnfProtocolVersion2//,
//                cryptoServicesDescriptor: VCLCryptoServicesDescriptor(
//                    cryptoServiceType: .Remote,
//                    remoteCryptoServicesUrlsDescriptor: VCLRemoteCryptoServicesUrlsDescriptor(
//                        keyServiceUrls: VCLKeyServiceUrls(
//                            createDidKeyServiceUrl: Constants.getCreateDidKeyServiceUrl(environment: environment)
//                        ),
//                        jwtServiceUrls: VCLJwtServiceUrls(
//                            jwtSignServiceUrl: Constants.getJwtSignServiceUrl(environment: environment),
//                            jwtVerifyServiceUrl: Constants.getJwtVerifyServiceUrl(environment: environment))
//                    )
//                )
            ),
            successHandler: { [weak self] in
                NSLog("VCL Initialization succeed!")
                
                self?.vcl.generateDidJwk(
                    successHandler: { didJwk in
                        self?.didJwk = didJwk
                        NSLog(
                            "VCL DID:JWK generated: \ndid: \(didJwk.did)\nkid: \(didJwk.kid)\nkeyId: \(didJwk.keyId)\npublicJwk: \(didJwk.publicJwk.valueStr)"
                        )
                        self?.showControls()
                    },
                    errorHandler: { error in
                        NSLog("VCL Failed to generate did:jwk with error: \(error)")
                        self?.showError()
                    }
                )
            },
            errorHandler: { [weak self] error in
                NSLog("VCL Initialization failed with error: \(error)")
                self?.showError()
            }
        )
    }
    
    private func showControls() {
        loadingIndicator.stopAnimating()
        controlsView.isHidden = false
    }
    
    private func showError() {
        loadingIndicator.stopAnimating()
        errorView.isHidden = false
    }
    
    @objc private func getPresentationRequest() {
        let deepLink =
        environment == VCLEnvironment.Dev ?
        VCLDeepLink(value: Constants.PresentationRequestDeepLinkStrDev) :
        VCLDeepLink(value: Constants.PresentationRequestDeepLinkStrStaging)
        
        vcl.getPresentationRequest(
            presentationRequestDescriptor: VCLPresentationRequestDescriptor(
                deepLink: deepLink,
                pushDelegate: VCLPushDelegate(
                    pushUrl: "pushUrl",
                    pushToken: "pushToken"
                )),
            successHandler: { [weak self] presentationRequest in
                NSLog("VCL Presentation request received: \(presentationRequest.jwt.payload?.toJson() ?? "")")
                
                self?.submitPresentation(presentationRequest: presentationRequest)
            },
            errorHandler: {error in
                NSLog("VCL Presentation request failed: \(error)")
            }
        )
    }
    
    private func submitPresentation(presentationRequest: VCLPresentationRequest)  {
        let presentationSubmission = VCLPresentationSubmission(
            presentationRequest: presentationRequest,
            verifiableCredentials: Constants.PresentationSelectionsList
        )
        submitPresentation(presentationSubmission: presentationSubmission)
    }
    
    private func submitPresentation(presentationSubmission: VCLPresentationSubmission)  {
        vcl.submitPresentation(
            presentationSubmission: presentationSubmission,
            didJwk: self.didJwk,
            successHandler: { [weak self] presentationSubmissionResult in
                NSLog("VCL Presentation Submission result: \(presentationSubmissionResult)")
                self?.vcl.getExchangeProgress(
                    exchangeDescriptor: VCLExchangeDescriptor(
                        presentationSubmission: presentationSubmission,
                        submissionResult: presentationSubmissionResult
                    ),
                    successHandler: { exchange in
                        NSLog("VCL Presentation exchange progress \(exchange)")
                    },
                    errorHandler: { error in
                        NSLog("VCL Presentation exchange progress failed: \(error)")
                    }
                )
            },
            errorHandler: { error in
                NSLog("VCL Presentation submission failed: \(error)")
            }
        )
    }
    
    @objc private func getOrganizationsThenCredentialManifestByService() {
        let organizationDescriptor =
        environment == VCLEnvironment.Dev ?
        Constants.OrganizationsSearchDescriptorByDidDev :
        Constants.OrganizationsSearchDescriptorByDidStaging
        
        vcl.searchForOrganizations(
            organizationsSearchDescriptor: organizationDescriptor,
            successHandler: { [weak self] organizations in
                NSLog("VCL Organizations received: \(organizations.all)")
                
                // choosing services[0] for testing purposes
                if organizations.all.count == 0 || organizations.all[0].serviceCredentialAgentIssuers.isEmpty {
                    NSLog("VCL Organizations error, issuing service not found")
                } else {
                    self?.getCredentialManifestByService(serviceCredentialAgentIssuer: organizations.all[0].serviceCredentialAgentIssuers[0])
                }
            },
            errorHandler: { error in
                NSLog("VCL Organizations search failed: \(error)")
            }
        )
    }
    
    @objc private func refreshCredentials() {
        let service = VCLService(payload: Constants.IssuingServiceJsonStr.toDictionary()!)
        
        let credentialManifestDescriptorRefresh =
        VCLCredentialManifestDescriptorRefresh(
            service: service,
            credentialIds: Constants.CredentialIdsToRefresh
        )
        vcl.getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptorRefresh,
            successHandler: { credentialManifest in
                NSLog("VCL Vredentials refreshed, credential manifest: \(credentialManifest.jwt.payload?.toJson() ?? "")")
                //                 NSLog("VCL Credential Manifest received")
            },
            errorHandler: { error in
                NSLog("VCL Refresh credentials failed: \(error)")
            }
        )
    }
    
    private func getCredentialManifestByService(serviceCredentialAgentIssuer: VCLServiceCredentialAgentIssuer) {
        let credentialManifestDescriptorByOrganization =
        VCLCredentialManifestDescriptorByService(
            service: serviceCredentialAgentIssuer,
            //            issuingType: VCLIssuingType.Career,
            credentialTypes: serviceCredentialAgentIssuer.credentialTypes // Can come from any where
        )
        vcl.getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptorByOrganization,
            successHandler: { [weak self] credentialManifest in
                NSLog("VCL Credential Manifest received: \(credentialManifest.jwt.payload?.toJson() ?? "")")
                //                NSLog("VCL Credential Manifest received")
                
                self?.generateOffers(credentialManifest: credentialManifest)
            },
            errorHandler: { error in
                NSLog("VCL Get Credential Manifest failed: \(error)")
            }
        )
    }
    
    @objc private func getCredentialManifestByDeepLink() {
        let deepLink = environment == VCLEnvironment.Dev ?
        VCLDeepLink(value: Constants.CredentialManifestDeepLinkStrDev) :
        VCLDeepLink(value: Constants.CredentialManifestDeepLinkStrStaging)
        
        let credentialManifestDescriptorByDeepLink =
        VCLCredentialManifestDescriptorByDeepLink(
            deepLink: deepLink//,
            //            issuingType: VCLIssuingType.Identity
        )
        vcl.getCredentialManifest(
            credentialManifestDescriptor: credentialManifestDescriptorByDeepLink,
            successHandler: { [weak self] credentialManifest in
                NSLog("VCL Credential Manifest received: \(credentialManifest.jwt.payload as Optional)")
                
                self?.generateOffers(credentialManifest: credentialManifest)
            },
            errorHandler: { error in
                NSLog("VCL Credential Manifest failed: \(error)")
            })
    }
    
    private func generateOffers(credentialManifest: VCLCredentialManifest) {
        let generateOffersDescriptor = VCLGenerateOffersDescriptor(
            credentialManifest: credentialManifest,
            types: Constants.CredentialTypes,
            identificationVerifiableCredentials: Constants.IdentificationList
        )
        vcl.generateOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            didJwk: self.didJwk,
            successHandler: { [weak self] offers in
                NSLog("VCL Generated Offers: \(offers.all)")
                NSLog("VCL Generated Offers Response Code: \(offers.responseCode)")
                NSLog("VCL Generated Offers Token: \(offers.issuingToken)")
                
                //                Check offers invoked after the push notification is notified the app that offers are ready:
                self?.checkForOffers(
                    credentialManifest: credentialManifest,
                    generateOffersDescriptor: generateOffersDescriptor,
                    issuingToken: offers.issuingToken
                )
            },
            errorHandler: { error in
                NSLog("VCL failed to Generate Offers: \(error)")
            }
        )
    }
    
    private func checkForOffers(
        credentialManifest: VCLCredentialManifest,
        generateOffersDescriptor: VCLGenerateOffersDescriptor,
        issuingToken: VCLToken
    ) {
        vcl.checkForOffers(
            generateOffersDescriptor: generateOffersDescriptor,
            issuingToken:                     issuingToken,
            successHandler: { [weak self] offers in
                NSLog("VCL Checked Offers: \(offers.all)")
                NSLog("VCL Checked Offers Response Code: \(offers.responseCode)")
                NSLog("VCL Checked Offers Token: \(offers.issuingToken)")
                if (offers.responseCode == 200) {
                    self?.finalizeOffers(
                        credentialManifest: credentialManifest,
                        offers: offers
                    )
                }
            },
            errorHandler: { error in
                NSLog("VCL failed to Check Offers: \(error)")
            }
        )
    }
    
    private func finalizeOffers(
        credentialManifest: VCLCredentialManifest,
        offers: VCLOffers
    ) {
        let approvedRejectedOfferIds = Utils.getApprovedRejectedOfferIdsMock(offers: offers)
        let finalizeOffersDescriptor = VCLFinalizeOffersDescriptor(
            credentialManifest: credentialManifest,
            offers: offers,
            approvedOfferIds: approvedRejectedOfferIds.0,
            rejectedOfferIds: approvedRejectedOfferIds.1
        )
        vcl.finalizeOffers(
            finalizeOffersDescriptor: finalizeOffersDescriptor,
            didJwk: self.didJwk,
            issuingToken: offers.issuingToken,
            successHandler: { verifiableCredentials in
                NSLog("VCL finalized Offers")
                NSLog("VCL Passed Credentials: \(verifiableCredentials.passedCredentials)")
                NSLog("VCL Failed Credentials: \(verifiableCredentials.failedCredentials)")
            },
            errorHandler: { error in
                NSLog("VCL failed to finalize Offers: \(error)")
            }
        )
    }
    
    @objc private func getCredentialTypesUIFormSchema() {
        vcl.getCredentialTypesUIFormSchema(
            credentialTypesUIFormSchemaDescriptor: VCLCredentialTypesUIFormSchemaDescriptor(
                credentialType: Constants.ResidentPermitV10,
                countryCode: VCLCountries.Codes.CA
            ),
            successHandler: { credentialTypesUIFormSchema in
                NSLog("VCL received Credential Types UI Forms Schema: \(credentialTypesUIFormSchema.payload.toJson() ?? "")")
            },
            errorHandler: { error in
                NSLog("VCL failed to get Credential Types UI Forms Schema: \(error)")
            }
        )
    }
    
    @objc private func getVerifiedProfile() {
        vcl.getVerifiedProfile(
            verifiedProfileDescriptor: Constants.VerifiedProfileDescriptor,
            successHandler: { verifiedProfile in
                NSLog("VCL Verified Profile: \(verifiedProfile.payload)")
            },
            errorHandler: { error in
                NSLog("VCL Verified Profile failed: \(error)")
            }
        )
    }
    
    @objc private func verifyJwt() {
        vcl.verifyJwt(
            jwt: Constants.SomeJwt, publicJwk: Constants.SomePublicJwk, successHandler: { isVerified in
                NSLog("VCL JWT verified: \(isVerified)")
            },
            errorHandler: { error in
                NSLog("VCL JWT verification failed: \(error)")
            }
        )
    }
    
    @objc private func generateSignedJwt() {
        vcl.generateSignedJwt(
            jwtDescriptor: VCLJwtDescriptor(
                keyId: didJwk?.keyId,
                payload: Constants.SomePayload,
                jti: "jti123",
                iss: "iss123"
            ),
            successHandler: { jwt in
                NSLog("VCL JWT generated: \(jwt.encodedJwt)")
            },
            errorHandler: { error in
                NSLog("VCL JWT generation failed: \(error)")
            }
        )
    }
    
    @objc private func generateDidJwk() {
        vcl.generateDidJwk(
            successHandler: { [weak self] didJwk in
                self?.didJwk = didJwk
                NSLog(
                    "VCL DID:JWK generated: \ndid: \(didJwk.did)\nkid: \(didJwk.kid)\nkeyId: \(didJwk.keyId)\npublicJwk: \(didJwk.publicJwk.valueStr)"
                )
            },
            errorHandler: { error in
                NSLog("VCL did:jwk generation failed: \(error)")
            }
        )
    }
}

extension Dictionary {
    func toJson() -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .withoutEscapingSlashes)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
