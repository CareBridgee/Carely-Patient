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
    
    func makePhoneNumberViewModel(router: AuthRouter) -> PhoneNumberViewModel {
        PhoneNumberViewModel(
            loginUseCase: makeLoginUseCase(),
            router: router
        )
    }
    
    func makeWelcomeViewModel(router: AuthRouter) -> WelcomeViewModel {
        WelcomeViewModel(router: router)
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
                                         service: profileSetupService)
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
                saveConditions: SaveExistingConditionsUseCase(repo: profileSetupRepository),
                saveAllergies: SaveAllergiesUseCase(repo: profileSetupRepository),
                saveMedications: SaveMedicationsUseCase(repo: profileSetupRepository),
                saveHistory: SaveMedicalHistoryUseCase(repo: profileSetupRepository),
                saveContact: SaveEmergencyContactUseCase(repo: profileSetupRepository),
                saveAddress: SaveHomeAddressUseCase(repo: profileSetupRepository),
                updateAddress: UpdateHomeAddressUseCase(repo: profileSetupRepository)
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
    
    func makeExistingConditionsViewModel(existingData: ExistingConditions) -> ExistingConditionsViewModel {
        ExistingConditionsViewModel(existingData: existingData)
    }
    
    
    func makeEmergencyContactViewModel(initialContact: EmergencyContact?, overrideProfileId: String? = nil, coordinator: ProfileSetupCoordinator) -> EmergencyContactViewModel {
            EmergencyContactViewModel(
                initialContact: initialContact,
                getProfileIdUseCase: profileSetupUseCases.getProfileId,
                saveContactUseCase: profileSetupUseCases.saveContact,
                overrideProfileId: overrideProfileId, 
                onContinue: { contact in
                    coordinator.save(emergencyContact: contact)
                    coordinator.next()
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
            overrideProfileId: overrideProfileId,
            isEditingExistingAddress: false,
            onFinishSetup: { address in
                coordinator.save(homeAddress: address)
                onFinishSetup()
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
        serviceTypeService: serviceTypeService
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
    
    func makeHomeViewModel(onServiceTabbed: @escaping (String) -> Void) -> HomeViewModel {
        HomeViewModel(
            getGreetingNameUseCase: makeGetGreetingNameUseCase(),
            getServiceCategoriesUseCase: makeGetServiceCategoriesUseCase(),
            getUpcomingBookingsUseCase: makeGetUpcomingBookingsUseCase(),
            onServiceTabbed: onServiceTabbed
        )
    }
    
    func makeAllServiceViewModel(coordinator: ServicesCoordinator) -> AllServiceViewModel {
        AllServiceViewModel(
            getGreetingNameUseCase: makeGetGreetingNameUseCase(),
            getServiceCategoriesUseCase: makeGetServiceCategoriesUseCase(),
            searchServiceCategoriesUseCase: makeSearchServiceCategoriesUseCase(),
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
            overrideProfileId: profileId,
            isEditingExistingAddress: initialAddress != nil,
            onFinishSetup: { _ in onSaved() },          // moved up
            onBackTapped: { _ in onDismiss() },          // moved up
            showBackButton: false,                       // moved down
            continueButtonTitle: initialAddress != nil ? "Save Address" : "Add Address",
            loadingButtonTitle: "Saving..."
        )
    }
    func makeCareRequestViewModel(
        preselectedService: CareService,
        entryPoint: CareRequestEntryPoint,
        onSubmitted: @escaping (String) -> Void
    ) -> CareRequestViewModel {
        CareRequestViewModel(
            preselectedService: preselectedService,
            entryPoint: entryPoint,
            fetchAvailableServicesUseCase: FetchAvailableServicesUseCase(repository: careRequestRepository),
            fetchPatientsUseCase: FetchPatientsUseCase(repository: careRequestRepository),
            fetchProfileAddressUseCase: FetchProfileAddressUseCase(repository: careRequestRepository),
            submitCareRequestUseCase: SubmitCareRequestUseCase(repository: careRequestRepository),
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
        return OfferSearchingRepositoryImpl(hubService: dataSource)
    }
    
    // MARK: - Search Offer UseCases
    
    private func makeObserveOffersUseCase(repository: OfferSearchingRepositoryProtocol) -> ObserveOffersUseCase {
        ObserveOffersUseCase(repository: repository)
    }
    
    private func makeManageOffersConnectionUseCase(repository: OfferSearchingRepositoryProtocol) -> ManageOffersConnectionUseCase {
        ManageOffersConnectionUseCase(repository: repository)
    }
    
    // MARK: - Search Offer ViewModels
    
    func makeOffersSearchingViewModel(
        requestId: String,
        onOfferAccepted: @escaping (ConfirmedOffer)->Void,
        onShowNurseProfile: @escaping (String)->Void
    ) -> OffersSearchingViewModel {
        let repo = makeOfferSearchingRepository(serviceRequestId: requestId)
        
        return OffersSearchingViewModel(
            requestId: requestId,
            observeOffersUseCase: makeObserveOffersUseCase(repository: repo),
            manageOffersConnectionUseCase: makeManageOffersConnectionUseCase(repository: repo),
            onOfferAccepted: onOfferAccepted,
            onShowNurseProfile: onShowNurseProfile
        )
    }
    
    // MARK: - Offer Accepted ViewModels
    
    func makeOfferAcceptedViewModel(
        request: ConfirmedOffer,
        onShowQRCode: @escaping (ConfirmedOffer) -> Void,
        onCancelRequest: @escaping () -> Void,
        onShowNurseProfile: @escaping (String) -> Void
    ) -> OfferAcceptedViewModel {
        OfferAcceptedViewModel(
            request: request,
            onShowQRCode: onShowQRCode,
            onCancelRequest: onCancelRequest,
            onShowNurseProfile: onShowNurseProfile
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
    
    func makeNurseProfileViewModel(nurseId: String) -> NurseProfileViewModel {
        NurseProfileViewModel(nurseId: nurseId)
    }
    
    // MARK: - AIAssistant — Patient Selection

    private lazy var aiPatientRepository: AIPatientRepositoryProtocol = MockAIPatientRepository()

    private func makeGetAIPatientsUseCase() -> GetAIPatientsUseCaseProtocol {
        GetAIPatientsUseCase(repository: aiPatientRepository)
    }

    func makeChoosePatientViewModel(
        onShowPatientDetails: @escaping (String) -> Void,
        onContinueWithAssessment: @escaping (String) -> Void
    ) -> ChoosePatientViewModel {
        ChoosePatientViewModel(
            getAIPatientsUseCase: makeGetAIPatientsUseCase(),
            onShowPatientDetails: onShowPatientDetails,
            onContinueWithAssessment: onContinueWithAssessment
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

    func makeAIChatViewModel() -> AIChatViewModel {
        AIChatViewModel(sendAIChatMessageUseCase: makeSendAIChatMessageUseCase())
    }
    
    // MARK: - Profile Repository
    
    private lazy var profileRepository: ProfileRepositoryProtocol = ProfileRepositoryImpl()
    
    // MARK: - Profile UseCases
    
    private func makeGetPatientProfileUseCase() -> GetPatientProfileUseCaseProtocol {
        GetPatientProfileUseCase(repository: profileRepository)
    }
    
    private func makeGetFamilyMembersUseCase() -> GetFamilyMembersUseCaseProtocol {
        GetFamilyMembersUseCase(repository: profileRepository)
    }
    
    // MARK: - Profile ViewModels
    
    func makeProfileViewModel(coordinator: ProfileCoordinator) -> ProfileViewModel {
        ProfileViewModel(
            getPatientProfileUseCase: makeGetPatientProfileUseCase(),
            getFamilyMembersUseCase: makeGetFamilyMembersUseCase(),
            coordinator: coordinator
        )
    }
    
    func makeFamilyMembersViewModel(coordinator: ProfileCoordinator) -> FamilyMembersViewModel {
        FamilyMembersViewModel(
            getFamilyMembersUseCase: makeGetFamilyMembersUseCase(),
            coordinator: coordinator
        )
    }
    
    func makeSettingsViewModel(coordinator: ProfileCoordinator) -> SettingsViewModel {
        SettingsViewModel(
            patientName: "Elena Rodriguez",
            coordinator: coordinator
        )
    }
    
    // MARK: - Splash ViewModel
    
    func makeSplashViewModel() -> SplashViewModel {
        SplashViewModel()
    }
    
    // MARK: - Onboarding ViewModel
    
    func makeOnboardingViewModel(
        onNavigate: @escaping ()->Void
    ) -> OnboardingViewModel {
        OnboardingViewModel(onNavigate: onNavigate)
    }
}
