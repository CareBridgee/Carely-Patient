//
//  AppContainer.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation
import Alamofire

// I will instantiate it once at the absolute highest point
@MainActor
final class DIContainer {
    
    // MARK: - Auth Infrastructure
    
    let appState: AppState
    let patientProfilesStore = PatientProfilesStore()
    
    private let tokenStore: TokenStoring
    private let sessionManager: SessionManager
    private let unauthNetworkClient: NetworkClientProtocol
    private let authInterceptor: AuthInterceptor
    
    // MARK: - Networking (Single Stack)
    
    private lazy var session: Session = Session(interceptor: authInterceptor)
    
    private lazy var networkClient: NetworkClientProtocol = NetworkClient(session: session)
    
    // MARK: - Init
    
    init() {
        self.tokenStore = KeychainTokenStore()
        self.sessionManager = SessionManager(tokenStore: tokenStore)
        self.unauthNetworkClient = NetworkClient(session: .default)
        
        self.authInterceptor = AuthInterceptor(
            tokenStore: tokenStore,
            sessionMonitor: sessionManager,
            unauthNetworkClient: unauthNetworkClient
        )
        
        self.appState = AppState(sessionManager: sessionManager)
    }
    
    // MARK: - Auth Data
    
  
    private lazy var authService: AuthServiceProtocol = AuthServiceImpl(
        networkClient: networkClient,
        cloudinaryService: CloudinaryUploadService()
    )
    private lazy var authRepository: AuthRepositoryProtocol = AuthRepositoryImpl(
        authService: authService
    )
    
    // MARK: - Auth UseCases
    
    private func makeLoginUseCase() -> LoginUseCaseProtocol {
        LoginUseCase(repository: authRepository)
    }
    
    private func makeLogoutUseCase() -> LogoutUseCaseProtocol {
        LogoutUseCase(
            repository: authRepository,
            tokenStore: tokenStore,
            sessionManager: sessionManager
        )
    }
    
    private func makeRestoreSessionUseCase() -> RestoreSessionUseCaseProtocol {
        RestoreSessionUseCase(
            repository: authRepository,
            sessionManager: sessionManager
        )
    }
    
    private func makeSavePersonalInfoUseCase() -> SavePersonalInfoUseCaseProtocol {
            SavePersonalInfoUseCase(
                repository: authRepository,
                sessionManager: sessionManager
            )
        }
    private func makeVerifyOTPUseCase() -> VerifyOTPUseCaseProtocol {
        VerifyOTPUseCase(
            repository: authRepository,
            tokenStore: tokenStore,
            sessionManager: sessionManager
        )
    }
    
    // MARK: - Auth ViewModels
    
    func makeOTPVerificationViewModel(
        phoneNumber: String,
        router: AuthRouter,
        onAuthFinished: @escaping () -> Void
    ) -> OTPVerificationViewModel {
        OTPVerificationViewModel(
            phoneNumber: phoneNumber,
            verifyOTPUseCase: makeVerifyOTPUseCase(),
            loginUseCase: makeLoginUseCase(),
            router: router,
            onAuthFinished: onAuthFinished
        )
    }
    
    func makePersonalInfoViewModel(
        router: AuthRouter,
        onOersonalDataSaved: @escaping () -> Void
    ) -> PersonalInfoViewModel {
        PersonalInfoViewModel(
            savePersonalInfoUseCase: makeSavePersonalInfoUseCase(),
            router: router,
            onOersonalDataSaved: onOersonalDataSaved
        )
    }
    
    func makePhoneNumberViewModel(pendingToken: String?, router: AuthRouter) -> PhoneNumberViewModel {
            PhoneNumberViewModel(
                pendingToken: pendingToken,
                loginUseCase: makeLoginUseCase(),
                router: router
            )
        }
        
        func makeWelcomeViewModel(router: AuthRouter, onAuthFinished: @escaping () -> Void) -> WelcomeViewModel {
            WelcomeViewModel(
                router: router,
                repository: authRepository,
                tokenStore: tokenStore,
                sessionManager: sessionManager,
                onAuthFinished: onAuthFinished
            )
        }

    func makeOTPVerificationViewModel(
            phoneNumber: String,
            devOTP: String? = nil,
            pendingToken: String? = nil,
            router: AuthRouter,
            onAuthFinished: @escaping () -> Void,
            onGoToDecision: @escaping () -> Void
        ) -> OTPVerificationViewModel {
            OTPVerificationViewModel(
                phoneNumber: phoneNumber,
                devOTP: devOTP,
                pendingToken: pendingToken,
                verifyOTPUseCase: makeVerifyOTPUseCase(),
                loginUseCase: makeLoginUseCase(),
                router: router,
                onAuthFinished: onAuthFinished,
                onGoToDecision: onGoToDecision
            )
        }
    
    func makeProfileSetupDecisionViewModel(
        oncompleteHealthProfileClicked: @escaping () -> Void,
        onSkipButtonClicked: @escaping () -> Void
    ) -> ProfileSetupDecisionViewModel {
        ProfileSetupDecisionViewModel(
            oncompleteHealthProfileClicked: oncompleteHealthProfileClicked,
            onSkipButtonClicked: onSkipButtonClicked
        )
    }
    // 1. Service (API Calls)
        private lazy var profileSetupService: ProfileSetupServiceProtocol = {
            ProfileSetupServiceImpl(networkClient: networkClient)
        }()
        
        // 2. Repository (Data mapping)
        private lazy var profileSetupRepository: ProfileSetupRepositoryProtocol = {
            ProfileSetupRepositoryImpl(  searchService: MapSearchService(),
                                         geocodingService: GeocodingService(),
                                         locationProvider: CurrentLocationProvider(),
                                         service: profileSetupService,
                                         patientProfilesStore: patientProfilesStore)
        }()
    
 
    private lazy var profileSetupUseCases: ProfileSetupUseCases = {
            ProfileSetupUseCases(
                getProfileId: GetDefaultProfileIdUseCase(
                    repo: profileSetupRepository,
                    sessionManager: sessionManager
                ),
                createFamilyMemberProfile: CreateFamilyMemberProfileUseCase(repo: profileSetupRepository),
                updateBasicInfo: UpdateBasicHealthInfoUseCase(repo: profileSetupRepository),
                updateMobility: UpdateMobilityUseCase(repo: profileSetupRepository),
                fetchConditions: FetchMedicalConditionsUseCase(repo: profileSetupRepository),
                syncConditions: SyncMedicalConditionsUseCase(repo: profileSetupRepository),
                saveConditions: SaveExistingConditionsUseCase(repo: profileSetupRepository),
                fetchAllergies: FetchAllergiesUseCase(repo: profileSetupRepository),
                syncAllergies: SyncAllergiesUseCase(repo: profileSetupRepository),
                saveAllergies: SaveAllergiesUseCase(repo: profileSetupRepository),
                fetchMedications: FetchMedicationsUseCase(repo: profileSetupRepository),
                syncMedications: SyncMedicationsUseCase(repo: profileSetupRepository),
                saveMedications: SaveMedicationsUseCase(repo: profileSetupRepository),
                saveHistory: SaveMedicalHistoryUseCase(repo: profileSetupRepository),
                fetchContact: FetchEmergencyContactUseCase(repo: profileSetupRepository),
                saveContact: SaveEmergencyContactUseCase(repo: profileSetupRepository),
                saveAddress: SaveHomeAddressUseCase(repo: profileSetupRepository),
                updateAddress: UpdateHomeAddressUseCase(repo: profileSetupRepository),
                fetchAddress: FetchHomeAddressUseCase(repo: profileSetupRepository),
                geocodeAddress: GeocodeAddressUseCase(repository: profileSetupRepository)
            )
        }()
    func makeProfileSetupCoordinator() -> ProfileSetupCoordinator {
        ProfileSetupCoordinator(
            data: ProfileSetupData())
    }
    
    func makeMedicalHistoryViewModel(
        existingData: MedicalHistory,
        overrideProfileId: String? = nil,
        coordinator: ProfileSetupCoordinator
    ) -> MedicalHistoryViewModel {
        MedicalHistoryViewModel(
            existingData: existingData,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            saveMedicalHistoryUseCase: profileSetupUseCases.saveHistory,
            overrideProfileId: overrideProfileId,
            onContinue: { history in
                coordinator.save(medicalHistory: history)
                coordinator.next()
            },
            onBack: { history in
                coordinator.save(medicalHistory: history)
                coordinator.previous()
            }
        )
    }

    func makeMobilityViewModel(
        existingData: Mobility,
        overrideProfileId: String? = nil,
        coordinator: ProfileSetupCoordinator
    ) -> MobilityViewModel {
        MobilityViewModel(
            existingData: existingData,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            updateMobilityUseCase: profileSetupUseCases.updateMobility,
            overrideProfileId: overrideProfileId,
            onContinue: { mobility in
                coordinator.save(mobility: mobility)
                coordinator.next()
            },
            onBack: { mobility in
                coordinator.save(mobility: mobility)
                coordinator.previous()
            }
        )
    }
    
    func makeAddFamilyMemberInfoViewModel(
        onCreated: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) -> AddFamilyMemberInfoViewModel {
        AddFamilyMemberInfoViewModel(
            createFamilyMemberProfileUseCase: profileSetupUseCases.createFamilyMemberProfile,
            onCreated: onCreated,
            onBack: onBack
        )
    }

    func makeBasicInfoHealthViewModel(
        existingData: BasicHealthInfo,
        profileId: String,
        coordinator: ProfileSetupCoordinator
    ) -> BasicHealthInfoViewModel {
        BasicHealthInfoViewModel(
            existingData: existingData,
            getProfileIdUseCase: FixedProfileIdProvider(profileId: profileId),
            updateBasicInfoUseCase: profileSetupUseCases.updateBasicInfo,
            onContinue: { [weak coordinator] info in
                coordinator?.save(basicHealthInfo: info)
                coordinator?.next()
            },
            onBack: { [weak coordinator] info in
                coordinator?.save(basicHealthInfo: info)
                coordinator?.previous()
            }
        )
    }
    func makeBasicInfoHealthViewModel(
        existingData: BasicHealthInfo,
        coordinator: ProfileSetupCoordinator
    ) -> BasicHealthInfoViewModel {
        BasicHealthInfoViewModel(
            existingData: existingData,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            updateBasicInfoUseCase: profileSetupUseCases.updateBasicInfo,
            onContinue: { info in
                coordinator.save(basicHealthInfo: info)
                coordinator.next()
            },
            onBack: { info in
                coordinator.save(basicHealthInfo: info)
                coordinator.previous()
            }
        )
    }
    
    func makeExistingConditionsViewModel(
        existingData: ExistingConditions,
        overrideProfileId: String? = nil,
        coordinator: ProfileSetupCoordinator
    ) -> ExistingConditionsViewModel {
        ExistingConditionsViewModel(
            existingData: existingData,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            fetchConditionsUseCase: profileSetupUseCases.fetchConditions,
            syncConditionsUseCase: profileSetupUseCases.syncConditions,
            overrideProfileId: overrideProfileId,
            onContinue: { conditions in
                coordinator.save(existingConditions: conditions)
                coordinator.next()
            },
            onBack: { conditions in
                coordinator.save(existingConditions: conditions)
                coordinator.previous()
            }
        )
    }

    func makeAllergiesViewModel(
        coordinator: ProfileSetupCoordinator,
        overrideProfileId: String? = nil
    ) -> AllergiesViewModel {
        AllergiesViewModel(
            coordinator: coordinator,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            fetchAllergiesUseCase: profileSetupUseCases.fetchAllergies,
            syncAllergiesUseCase: profileSetupUseCases.syncAllergies,
            overrideProfileId: overrideProfileId
        )
    }

    func makeCurrentMedicationViewModel(
        coordinator: ProfileSetupCoordinator,
        overrideProfileId: String? = nil
    ) -> CurrentMedicationViewModel {
        CurrentMedicationViewModel(
            coordinator: coordinator,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            fetchMedicationsUseCase: profileSetupUseCases.fetchMedications,
            syncMedicationsUseCase: profileSetupUseCases.syncMedications,
            overrideProfileId: overrideProfileId
        )
    }
    
    

    func makeEmergencyContactViewModel(
        initialContact: EmergencyContact?,
        overrideProfileId: String? = nil,
        coordinator: ProfileSetupCoordinator,
        onFinish: (() -> Void)? = nil
    ) -> EmergencyContactViewModel {
        EmergencyContactViewModel(
            initialContact: initialContact,
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            fetchContactUseCase: profileSetupUseCases.fetchContact,
            saveContactUseCase: profileSetupUseCases.saveContact,
            overrideProfileId: overrideProfileId,
            onContinue: { contact in
                coordinator.save(emergencyContact: contact)
                if coordinator.isLastStep {
                    onFinish?()
                } else {
                    coordinator.next()
                }
            },
            onBack: { contact in
                coordinator.save(emergencyContact: contact)
                coordinator.previous()
            }
        )
    }
        
    func makeHomeAddressViewModel(
        initialAddress: HomeAddress?,
        overrideProfileId: String? = nil,
        coordinator: ProfileSetupCoordinator,
        onFinishSetup: @escaping () -> Void
    ) -> HomeAddressViewModel {
        let mapPickerVM = makeAddressMapPickerViewModel()

        let homeVM = HomeAddressViewModel(
            initialAddress: initialAddress,
            mapPickerViewModel: mapPickerVM,
            getCurrentLocationAddressUseCase: makeGetCurrentLocationAddressUseCase(),
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            saveAddressUseCase: profileSetupUseCases.saveAddress,
            updateAddressUseCase: profileSetupUseCases.updateAddress,
            fetchAddressUseCase: profileSetupUseCases.fetchAddress,
            geocodeAddressUseCase: profileSetupUseCases.geocodeAddress,
            overrideProfileId: overrideProfileId,
            isEditingExistingAddress: false,
            onFinishSetup: { address in
                coordinator.save(homeAddress: address)
                if coordinator.isLastStep {
                    onFinishSetup()
                } else {
                    coordinator.next()
                }
            },
            onBackTapped: { address in
                coordinator.save(homeAddress: address)
                coordinator.previous()
            }
        )

        mapPickerVM.onConfirm = { [weak homeVM] selection in homeVM?.handleAddressSelection(selection) }
        mapPickerVM.onClose = { [weak homeVM] in homeVM?.closeMapPicker() }

        return homeVM
    }
    
    // MARK: - Home Address Repository
  
    
    // MARK: - Home Address Use Cases
    
    private func makeSearchPlacesUseCase() -> SearchPlacesUseCase {
        SearchPlacesUseCase(repository: profileSetupRepository)
    }
    
    private func makeResolveLocationUseCase() -> ResolveLocationUseCase {
        ResolveLocationUseCase(repository: profileSetupRepository)
    }
    
    private func makeReverseGeocodeUseCase() -> ReverseGeocodeUseCase {
        ReverseGeocodeUseCase(repository: profileSetupRepository)
    }
    
    private func makeGeocodeCountryUseCase() -> GeocodeCountryUseCase {
        GeocodeCountryUseCase(repository: profileSetupRepository)
    }
    
    private func makeGetCurrentLocationCoordinateUseCase() -> GetCurrentLocationCoordinateUseCase {
        GetCurrentLocationCoordinateUseCase(repository: profileSetupRepository)
    }
    
    private func makeGetCurrentLocationAddressUseCase() -> GetCurrentLocationAddressUseCase {
        GetCurrentLocationAddressUseCase(repository: profileSetupRepository)
    }
    
    // MARK: - Address Map Picker ViewModel
    
    private func makeAddressMapPickerViewModel() -> AddressMapPickerViewModel {
        AddressMapPickerViewModel(
            searchPlacesUseCase: makeSearchPlacesUseCase(),
            resolveLocationUseCase: makeResolveLocationUseCase(),
            reverseGeocodeUseCase: makeReverseGeocodeUseCase(),
            geocodeCountryUseCase: makeGeocodeCountryUseCase(),
            getCurrentLocationCoordinateUseCase: makeGetCurrentLocationCoordinateUseCase()
        )
    }
    // MARK: - Core Socket (Shared)
        private lazy var sharedSocketClient: SocketClientProtocol = {
            guard let url = URL(string: NetworkConfiguration.socketURL) else {
                fatalError("Invalid socket URL")
            }
            
            let client = StompSocketClient(url: url, tokenStore: tokenStore)
            
            client.onTokenExpiredOrFailed = { [weak self] in
                guard let self = self else { return false }
                
                guard let refreshToken = self.tokenStore.getRefreshToken(), !refreshToken.isEmpty else {
                    return false
                }
                
                do {
                    let authResponse = try await self.authService.refresh(refreshToken: refreshToken)
                    
                    self.tokenStore.saveTokens(
                        access: authResponse.accessToken,
                        refresh: authResponse.refreshToken
                    )
                    
                    return true
                } catch {
                    print("[Socket] Direct token refresh failed: \(error)")
                    return false
                }
            }
            
            return client
        }()
    // MARK: - Service Catalog (shared by Home + Services features)

    private lazy var serviceTypeService: ServiceTypeServiceProtocol = ServiceTypeServiceImpl(
        networkClient: networkClient
    )

    // MARK: - Home Repository

        private lazy var homeRepository: HomeRepositoryProtocol = HomeRepositoryImpl(
            serviceTypeService: serviceTypeService,
            historyService: historyService
        )
    
    private lazy var serviceRequestService: ServiceRequestServiceProtocol = ServiceRequestServiceImpl(networkClient: networkClient)

    private lazy var careRequestRepository: CareRequestRepositoryProtocol = CareRequestRepositoryImpl(
        serviceTypeService: serviceTypeService,
        serviceRequestService: serviceRequestService
    )
    
    
    // MARK: - Home UseCases
    
    private func makeGetGreetingNameUseCase() -> GetGreetingNameUseCaseProtocol {
            GetGreetingNameUseCase(sessionManager: sessionManager)
        }
    
    private func makeGetServiceCategoriesUseCase() -> GetServiceCategoriesUseCaseProtocol {
        GetServiceCategoriesUseCase(repository: homeRepository)
    }
    
    private func makeGetUpcomingBookingsUseCase() -> GetUpcomingBookingsUseCaseProtocol {
        GetUpcomingBookingsUseCase(repository: homeRepository)
    }
    
    private func makeGetServiceDetailUseCase() -> GetServiceDetailUseCaseProtocol {
        GetServiceDetailUseCase(repository: homeRepository)
    }
    
    private func makeSearchServiceCategoriesUseCase() -> SearchServiceCategoriesUseCaseProtocol {
        SearchServiceCategoriesUseCase(repository: homeRepository)
    }
    
    // MARK: - Home ViewModels
    
    func makeHomeViewModel(
        onServiceTabbed: @escaping (String) -> Void,
        onSeeAllHistory: @escaping () -> Void = {}
    ) -> HomeViewModel {
        HomeViewModel(
            getServiceCategoriesUseCase: makeGetServiceCategoriesUseCase(),
            getUpcomingBookingsUseCase: makeGetUpcomingBookingsUseCase(),
            sessionManager: sessionManager,
            onServiceTabbed: onServiceTabbed,
            onSeeAllHistory: onSeeAllHistory
        )
    }
    
    func makeAllServiceViewModel(coordinator: ServicesCoordinator) -> AllServiceViewModel {
        AllServiceViewModel(
            getServiceCategoriesUseCase: makeGetServiceCategoriesUseCase(),
            searchServiceCategoriesUseCase: makeSearchServiceCategoriesUseCase(),
            sessionManager: sessionManager,
            coordinator: coordinator
        )
    }
    
    func makeServiceDetailsViewModel(serviceId: String, source: ServiceDetailsSource, coordinator: ServicesCoordinator) -> ServiceDetailsViewModel {
        ServiceDetailsViewModel(
            serviceId: serviceId,
            getServiceDetailUseCase: makeGetServiceDetailUseCase(),
            source: source,
            coordinator: coordinator
        )
    }
    func makeAddressSheetViewModel(
        profileId: String,
        initialAddress: HomeAddress?,
        onSaved: @escaping () -> Void,
        onDismiss: @escaping () -> Void
    ) -> HomeAddressViewModel {
        HomeAddressViewModel(
            initialAddress: initialAddress,
            mapPickerViewModel: makeAddressMapPickerViewModel(),
            getCurrentLocationAddressUseCase: makeGetCurrentLocationAddressUseCase(),
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            saveAddressUseCase: profileSetupUseCases.saveAddress,
            updateAddressUseCase: profileSetupUseCases.updateAddress,
            fetchAddressUseCase: profileSetupUseCases.fetchAddress,
            geocodeAddressUseCase: profileSetupUseCases.geocodeAddress,
            overrideProfileId: profileId,
            isEditingExistingAddress: initialAddress != nil && !(initialAddress?.isEmpty ?? true),
            onFinishSetup: { _ in onSaved() },          // moved up
            onBackTapped: { _ in onDismiss() },          // moved up
            showBackButton: false,                       // moved down
            continueButtonTitle: (initialAddress != nil && !(initialAddress?.isEmpty ?? true)) ? "Save Address" : "Add Address",
            loadingButtonTitle: "Saving..."
        )
    }
    func makeCareRequestViewModel(
        preselectedService: CareService,
        entryPoint: CareRequestEntryPoint,
        aiDraft: ReservationDraft? = nil,
        aiProfileId: String? = nil,
        onSubmitted: @escaping (String) -> Void
    ) -> CareRequestViewModel {
        CareRequestViewModel(
            preselectedService: preselectedService,
            entryPoint: entryPoint,
            aiDraft: aiDraft,
            aiProfileId: aiProfileId,
            fetchAvailableServicesUseCase: FetchAvailableServicesUseCase(repository: careRequestRepository),
            fetchProfileAddressUseCase: FetchProfileAddressUseCase(repository: careRequestRepository),
            submitCareRequestUseCase: SubmitCareRequestUseCase(repository: careRequestRepository),
            patientProfilesStore: patientProfilesStore,
            makeAddressSheetViewModel: { profileId, initialAddress, onSaved, onDismiss in
                self.makeAddressSheetViewModel(
                    profileId: profileId,
                    initialAddress: initialAddress,
                    onSaved: onSaved,
                    onDismiss: onDismiss
                )
            },
            onSubmitted: onSubmitted
        )
    }
    // MARK: - Visit Summary Repository
    
    private lazy var visitSummaryRepository: VisitSummaryRepositoryProtocol = {
        VisitSummaryRepositoryImpl()
    }()
    
    // MARK: - Visit Summary UseCases
    
    private func makeGetVisitSummaryUseCase() -> GetVisitSummaryUseCaseProtocol {
        GetVisitSummaryUseCase(repository: visitSummaryRepository)
    }
    
    private func makeSubmitVisitRatingUseCase() -> SubmitVisitRatingUseCaseProtocol {
        SubmitVisitRatingUseCase(repository: visitSummaryRepository)
    }
    
    // MARK: - Visit Summary ViewModels
    
    func makeVisitCompletedViewModel(visitId: String, onFinished: @escaping () -> Void = {}) -> VisitCompletedViewModel {
        VisitCompletedViewModel(
            visitId: visitId,
            getVisitSummaryUseCase: makeGetVisitSummaryUseCase(),
            submitVisitRatingUseCase: makeSubmitVisitRatingUseCase(),
            onFinished: onFinished
        )
    }
    
    // MARK: - Core Socket
    
    private func makeSocketClient(serviceRequestId: String) -> SocketClientProtocol {
            return sharedSocketClient
        }

        // MARK: - Notifications
        private lazy var notificationsHubService: NotificationsHubServiceProtocol = {
            return NotificationsSocketDataSource(socketClient: sharedSocketClient)
        }()
        
        func getNotificationsHubService() -> NotificationsHubServiceProtocol {
            return notificationsHubService
        }

    // MARK: - Search Offer Repository
    
    private func makeOfferSearchingRepository(serviceRequestId: String) -> OfferSearchingRepositoryProtocol {
        let socketClient = makeSocketClient(serviceRequestId: serviceRequestId)
        let dataSource = OffersSearchingSocketDataSource(
            socketClient: socketClient,
            serviceRequestId: serviceRequestId
        )
        return OfferSearchingRepositoryImpl(
            hubService: dataSource,
            serviceRequestService: serviceRequestService
        )
    }
    
    // MARK: - Search Offer UseCases
    
    private func makeObserveOffersUseCase(repository: OfferSearchingRepositoryProtocol) -> ObserveOffersUseCase {
        ObserveOffersUseCase(repository: repository)
    }
    
    private func makeManageOffersConnectionUseCase(repository: OfferSearchingRepositoryProtocol) -> ManageOffersConnectionUseCase {
        ManageOffersConnectionUseCase(repository: repository)
    }
    
    private func makeAcceptOfferUseCase(repository: OfferSearchingRepositoryProtocol) -> AcceptOfferUseCase {
        AcceptOfferUseCase(repository: repository)
    }
    
    private func makeDeclineOfferUseCase(repository: OfferSearchingRepositoryProtocol) -> DeclineOfferUseCase {
        DeclineOfferUseCase(repository: repository)
    }
    
    private func makeCancelServiceRequestUseCase(repository: OfferSearchingRepositoryProtocol) -> CancelServiceRequestUseCase {
        CancelServiceRequestUseCase(repository: repository)
    }
    
    // MARK: - Search Offer ViewModels
    
    func makeOffersSearchingViewModel(
        requestId: String,
        onOfferAccepted: @escaping (ConfirmedOffer)->Void,
        onShowNurseProfile: @escaping (String)->Void,
        onSearchCanceled: @escaping () -> Void
    ) -> OffersSearchingViewModel {
        let repo = makeOfferSearchingRepository(serviceRequestId: requestId)
        
        return OffersSearchingViewModel(
            requestId: requestId,
            observeOffersUseCase: makeObserveOffersUseCase(repository: repo),
            manageOffersConnectionUseCase: makeManageOffersConnectionUseCase(repository: repo),
            acceptOfferUseCase: makeAcceptOfferUseCase(repository: repo),
            declineOfferUseCase: makeDeclineOfferUseCase(repository: repo),
            cancelServiceRequestUseCase: makeCancelServiceRequestUseCase(repository: repo),
            onOfferAccepted: onOfferAccepted,
            onShowNurseProfile: onShowNurseProfile,
            onSearchCanceled: onSearchCanceled
        )
    }
    
    // MARK: - Offer Accepted ViewModels
    
    func makeOfferAcceptedViewModel(
        request: ConfirmedOffer,
        onShowQRCode: @escaping (ConfirmedOffer) -> Void,
        onCancelRequest: @escaping () -> Void,
        onShowNurseProfile: @escaping (String) -> Void,
        onMessageNurse: @escaping (String) -> Void
    ) -> OfferAcceptedViewModel {
        let repo = makeOfferSearchingRepository(serviceRequestId: request.id)
        
        return OfferAcceptedViewModel(
            request: request,
            cancelServiceRequestUseCase: makeCancelServiceRequestUseCase(repository: repo),
            observeOffersUseCase: makeObserveOffersUseCase(repository: repo),
            manageOffersConnectionUseCase: makeManageOffersConnectionUseCase(repository: repo),
            onShowQRCode: onShowQRCode,
            onCancelRequest: onCancelRequest,
            onShowNurseProfile: onShowNurseProfile,
            onMessageNurse: onMessageNurse
        )
    }
    
    // MARK: - QR Code ViewModels
    
    func makeArrivalQRCodeViewModel(
        qrCodeData: String,
        referenceNumber: String,
        onClose: @escaping () -> Void
    ) -> ArrivalQRCodeViewModel {
        ArrivalQRCodeViewModel(
            qrCodeData: qrCodeData,
            referenceNumber: referenceNumber,
            onClose: onClose
        )
    }
    
    // MARK: - Nurse Profile ViewModels
    
//    func makeNurseProfileViewModel(nurseId: String) -> NurseProfileViewModel {
//        NurseProfileViewModel(nurseId: nurseId)
//    }
    
    // MARK: - AIAssistant — Patient Selection

    private lazy var aiPatientRepository: AIPatientRepositoryProtocol = AIPatientRepositoryImpl(
        serviceRequestService: serviceRequestService
    )

    private func makeGetAIPatientsUseCase() -> GetAIPatientsUseCaseProtocol {
        GetAIPatientsUseCase(repository: aiPatientRepository)
    }

    func makeChoosePatientViewModel(
        onShowPatientDetails: ((String) -> Void)? = nil,
        onContinueWithAssessment: @escaping (String) -> Void,
        onAddFamilyMember: (() -> Void)? = nil
    ) -> ChoosePatientViewModel {
        ChoosePatientViewModel(
            patientProfilesStore: patientProfilesStore,
            sessionManager: sessionManager,
            onShowPatientDetails: onShowPatientDetails,
            onContinueWithAssessment: onContinueWithAssessment,
            onAddFamilyMember: onAddFamilyMember
        )
    }

    // MARK: - AIAssistant — Chat

    private lazy var aiChatService: AIChatServiceProtocol = AIChatServiceImpl(
        networkClient: networkClient
    )

    private lazy var aiChatRepository: AIChatRepositoryProtocol = AIChatRepositoryImpl(
        service: aiChatService
    )

    private func makeSendAIChatMessageUseCase() -> SendAIChatMessageUseCaseProtocol {
        SendAIChatMessageUseCase(repository: aiChatRepository)
    }

    func makeResetAIChatUseCase() -> ResetAIChatUseCaseProtocol {
        ResetAIChatUseCase(repository: aiChatRepository)
    }

    func makeAIChatViewModel(
        profileId: String,
        coordinator: AIAssistantCoordinator? = nil
    ) -> AIChatViewModel {
        AIChatViewModel(
            profileId: profileId,
            sendAIChatMessageUseCase: makeSendAIChatMessageUseCase(),
            resetAIChatUseCase: makeResetAIChatUseCase(),
            onDismiss: { [weak coordinator] in
                coordinator?.pop()
            },
            onProceedToBooking: { [weak coordinator] draft in
                coordinator?.requestNowTapped(draft: draft, profileId: profileId)
            }
        )
    }
    
    // MARK: - Profile Network Service

    private lazy var profileNetworkService: ProfileNetworkServiceProtocol =
    ProfileNetworkService(networkClient: networkClient, sessionManager: sessionManager)

    func makeProfileNetworkService() -> ProfileNetworkServiceProtocol {
        profileNetworkService
    }

    // MARK: - Profile Repository

    private lazy var profileRepository: ProfileRepositoryProtocol =
        ProfileRepositoryImpl(service: profileNetworkService, store: patientProfilesStore, sessionManager: sessionManager)

    // MARK: - Profile UseCases

    private func makeGetPatientProfileUseCase() -> GetPatientProfileUseCaseProtocol {
        GetPatientProfileUseCase(repository: profileRepository)
    }

    private func makeGetFamilyMembersUseCase() -> GetFamilyMembersUseCaseProtocol {
        GetFamilyMembersUseCase(repository: profileRepository)
    }

    func makeUpdateProfileUseCase() -> UpdateProfileUseCaseProtocol {
        UpdateProfileUseCase(repository: profileRepository)
    }

    private func makeDeleteProfileUseCase() -> DeleteProfileUseCaseProtocol {
        DeleteProfileUseCase(repository: profileRepository)
    }

    // MARK: - Profile ViewModels

    func makeProfileViewModel(coordinator: ProfileCoordinator) -> ProfileViewModel {
        ProfileViewModel(
            getPatientProfileUseCase: makeGetPatientProfileUseCase(),
            getFamilyMembersUseCase: makeGetFamilyMembersUseCase(),
            logoutUseCase: makeLogoutUseCase(),
            coordinator: coordinator,
            sessionManager: sessionManager,
            patientProfilesStore: patientProfilesStore
        )
    }

    func makeFamilyMembersViewModel(coordinator: ProfileCoordinator) -> FamilyMembersViewModel {
        FamilyMembersViewModel(
            getFamilyMembersUseCase: makeGetFamilyMembersUseCase(),
            deleteProfileUseCase: makeDeleteProfileUseCase(),
            patientProfilesStore: patientProfilesStore,
            coordinator: coordinator
        )
    }

    func makeSettingsViewModel(coordinator: ProfileCoordinator) -> SettingsViewModel {
        let user = sessionManager.currentUser
        let firstName = user?.firstName ?? ""
        let lastName  = user?.lastName  ?? ""
        let name = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        return SettingsViewModel(
            patientName: name.isEmpty ? "My Profile" : name,
            coordinator: coordinator
        )
    }

    /// Personal Info edit — pre-populates from sessionManager + profile (if already loaded).
    func makeProfilePersonalInfoViewModel(
        profileId: String,
        coordinator: ProfileCoordinator,
        profile: PatientProfile? = nil
    ) -> ProfilePersonalInfoViewModel {
        ProfilePersonalInfoViewModel(
            profileId: profileId,
            profile: profile,
            sessionManager: sessionManager,
            updateUseCase: makeUpdateProfileUseCase(),
            coordinator: coordinator,
            patientProfilesStore: patientProfilesStore
        )
    }

    /// Health Profile edit — reuses step-based ProfileSetupCoordinator flow in edit mode.
    func makeProfileHealthSetupCoordinator(profileId: String) -> ProfileSetupCoordinator {
        let healthSteps: [ProfileSetupStep] = [
            .basicHealthInfo,
            .existingConditions,
            .allergies,
            .currentMedication,
            .medicalHistory,
            .mobility,
            .emergencyContact
        ]
        let setupCoordinator = ProfileSetupCoordinator(
            data: ProfileSetupData(),
            steps: healthSteps,
            startingStep: .basicHealthInfo
        )
        setupCoordinator.setProfileId(profileId)
        return setupCoordinator
    }

    /// Profile Address view model factory.
    func makeProfileAddressViewModel(
        profileId: String,
        coordinator: ProfileCoordinator
    ) -> ProfileAddressViewModel {
        let mapPickerVM = makeAddressMapPickerViewModel()
        let homeVM = HomeAddressViewModel(
            initialAddress: nil,
            mapPickerViewModel: mapPickerVM,
            getCurrentLocationAddressUseCase: makeGetCurrentLocationAddressUseCase(),
            getProfileIdUseCase: profileSetupUseCases.getProfileId,
            saveAddressUseCase: profileSetupUseCases.saveAddress,
            updateAddressUseCase: profileSetupUseCases.updateAddress,
            fetchAddressUseCase: profileSetupUseCases.fetchAddress,
            geocodeAddressUseCase: profileSetupUseCases.geocodeAddress,
            overrideProfileId: profileId,
            isEditingExistingAddress: false,
            onFinishSetup: { _ in coordinator.pop() },
            onBackTapped: { _ in coordinator.pop() },
            showBackButton: true,
            continueButtonTitle: "Save Address",
            loadingButtonTitle: "Saving..."
        )
        return ProfileAddressViewModel(
            initialProfileId: profileId,
            homeAddressViewModel: homeVM,
            getPatientProfileUseCase: makeGetPatientProfileUseCase(),
            getFamilyMembersUseCase: makeGetFamilyMembersUseCase(),
            coordinator: coordinator
        )
    }

    /// Health Profile edit — pre-populates from cached profile if provided.
    func makeProfileHealthViewModel(
        profileId: String,
        coordinator: ProfileCoordinator,
        profile: PatientProfile? = nil
    ) -> ProfileHealthViewModel {
        ProfileHealthViewModel(
            profileId: profileId,
            profile: profile,
            updateUseCase: makeUpdateProfileUseCase(),
            coordinator: coordinator
        )
    }
    
    // MARK: - Splash ViewModel
    
    func makeSplashViewModel() -> SplashViewModel {
        SplashViewModel(
            sessionManager: sessionManager,
            restoreSessionUseCase: makeRestoreSessionUseCase()
        )
    }
    
    // MARK: - Onboarding ViewModel
    
    func makeOnboardingViewModel(
        onNavigate: @escaping ()->Void
    ) -> OnboardingViewModel {
        OnboardingViewModel(onNavigate: onNavigate)
    }
    
    // MARK: - Nurse Profile Data

    private lazy var nurseService: NurseServiceProtocol = NurseServiceImpl(
        networkClient: networkClient
    )
    private lazy var nurseRepository: NurseRepositoryProtocol = NurseRepositoryImpl(
        service: nurseService
    )

    // MARK: - Nurse Profile UseCases

    private func makeGetNurseProfileUseCase() -> GetNurseProfileUseCaseProtocol {
        GetNurseProfileUseCase(repository: nurseRepository)
    }

    // MARK: - Nurse Profile ViewModels

    func makeNurseProfileViewModel(nurseId: String) -> NurseProfileViewModel {
        NurseProfileViewModel(
            nurseId: nurseId,
            getNurseProfileUseCase: makeGetNurseProfileUseCase()
        )
    }

    // MARK: - Reservation Chat
    
    private func makeChatHubService(reservationId: String) -> ChatHubServiceProtocol {
        ChatHubService(socketClient: makeSocketClient(serviceRequestId: reservationId), reservationId: reservationId)
    }
    
    private func makeChatNetworkService() -> ChatNetworkServiceProtocol {
        ChatNetworkService(networkClient: networkClient)
    }
    
    private func makeChatRepository(reservationId: String) -> ChatRepositoryProtocol {
        ChatRepository(
            hubService: makeChatHubService(reservationId: reservationId),
            networkService: makeChatNetworkService()
        )
    }
    
    func makeChatViewModel(reservationId: String, nurseName: String? = nil, nurseImageUrl: String? = nil) -> ChatViewModel {
        ChatViewModel(
            repository: makeChatRepository(reservationId: reservationId),
            reservationId: reservationId,
            currentUserId: sessionManager.currentUser?.id ?? "",
            nurseName: nurseName,
            nurseImageUrl: nurseImageUrl
        )
    }

    // MARK: - History Data

    private lazy var historyService: HistoryServiceProtocol = HistoryServiceImpl(
        networkClient: networkClient
    )
    private lazy var historyRepository: HistoryRepositoryProtocol = HistoryRepositoryImpl(
        historyService: historyService
    )

    // MARK: - History UseCases

    private func makeGetHistoryUseCase() -> GetHistoryUseCaseProtocol {
        GetHistoryUseCase(repository: historyRepository)
    }

    private func makeGetVisitDetailUseCase() -> GetVisitDetailUseCaseProtocol {
        GetVisitDetailUseCase(repository: historyRepository)
    }

    // MARK: - History ViewModels

    func makeHistoryViewModel(coordinator: HistoryCoordinator) -> HistoryViewModel {
        HistoryViewModel(
            getHistoryUseCase: makeGetHistoryUseCase(),
            coordinator: coordinator
        )
    }

    func makeVisitDetailViewModel(visitId: String) -> VisitDetailViewModel {
        VisitDetailViewModel(
            visitId: visitId,
            getVisitDetailUseCase: makeGetVisitDetailUseCase()
        )
    }
}
