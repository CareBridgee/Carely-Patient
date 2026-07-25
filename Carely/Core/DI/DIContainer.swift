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
        networkClient: networkClient
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
        SavePersonalInfoUseCase(repository: authRepository)
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
    
    func makeProfileSetupCoordinator() -> ProfileSetupCoordinator {
        ProfileSetupCoordinator(
            data: ProfileSetupData())
    }
    
    func makeMedicalHistoryViewModel(coordinator: ProfileSetupCoordinator) -> MedicalHistoryViewModel {
        MedicalHistoryViewModel(coordinator: coordinator)
    }
    
    func makeMobilityViewModel(coordinator: ProfileSetupCoordinator) -> MobilityViewModel {
        MobilityViewModel(coordinator: coordinator)}
    func makeBasicInfoHealthViewModel(existingData: BasicHealthInfo) -> BasicHealthInfoViewModel{
        BasicHealthInfoViewModel(existingData: existingData)
    }
    
    func makeExistingConditionsViewModel(existingData: ExistingConditions) -> ExistingConditionsViewModel {
        ExistingConditionsViewModel(existingData: existingData)
    }
    
    
    func makeEmergencyContactViewModel(
        initialContact: EmergencyContact?,
        onContinue: @escaping (EmergencyContact) -> Void,
        onBack: @escaping () -> Void
    ) -> EmergencyContactViewModel {
        EmergencyContactViewModel(initialContact: initialContact, onContinue: onContinue, onBack: onBack)
    }
    
    func makeHomeAddressViewModel(
        initialAddress: HomeAddress?,
        onFinishSetup: @escaping (HomeAddress) -> Void,
        onBackTapped: @escaping () -> Void
    ) -> HomeAddressViewModel {
        let mapPickerVM = makeAddressMapPickerViewModel()
        
        let homeVM = HomeAddressViewModel(
            initialAddress: initialAddress,
            mapPickerViewModel: mapPickerVM,
            getCurrentLocationAddressUseCase: makeGetCurrentLocationAddressUseCase(),
            onFinishSetup: onFinishSetup,
            onBackTapped: onBackTapped
        )
        
        mapPickerVM.onConfirm = { [weak homeVM] selection in
            homeVM?.handleAddressSelection(selection)
        }
        mapPickerVM.onClose = { [weak homeVM] in
            homeVM?.closeMapPicker()
        }
        
        return homeVM
    }
    
    // MARK: - Home Address Repository
    
    private lazy var homeAddressRepository: HomeAddressRepositoryProtocol = HomeAddressRepositoryImpl(
        searchService: MapSearchService(),
        geocodingService: GeocodingService(),
        locationProvider: CurrentLocationProvider()
    )
    
    // MARK: - Home Address Use Cases
    
    private func makeSearchPlacesUseCase() -> SearchPlacesUseCase {
        SearchPlacesUseCase(repository: homeAddressRepository)
    }
    
    private func makeResolveLocationUseCase() -> ResolveLocationUseCase {
        ResolveLocationUseCase(repository: homeAddressRepository)
    }
    
    private func makeReverseGeocodeUseCase() -> ReverseGeocodeUseCase {
        ReverseGeocodeUseCase(repository: homeAddressRepository)
    }
    
    private func makeGeocodeCountryUseCase() -> GeocodeCountryUseCase {
        GeocodeCountryUseCase(repository: homeAddressRepository)
    }
    
    private func makeGetCurrentLocationCoordinateUseCase() -> GetCurrentLocationCoordinateUseCase {
        GetCurrentLocationCoordinateUseCase(repository: homeAddressRepository)
    }
    
    private func makeGetCurrentLocationAddressUseCase() -> GetCurrentLocationAddressUseCase {
        GetCurrentLocationAddressUseCase(repository: homeAddressRepository)
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
    
    // MARK: - Home Repository
    
    private lazy var homeRepository: HomeRepositoryProtocol = HomeRepositoryImpl()
    
    // MARK: - Home UseCases
    
    private func makeGetGreetingNameUseCase() -> GetGreetingNameUseCaseProtocol {
        GetGreetingNameUseCase(repository: homeRepository)
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
    
    func makeHomeViewModel(onServiceTabbed: @escaping () -> Void) -> HomeViewModel {
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
    private lazy var careRequestRepository: CareRequestRepositoryProtocol = {
        CareRequestRepositoryImpl()
    }()
    
    func makeCareRequestViewModel(
        preselectedService: CareService,
        entryPoint: CareRequestEntryPoint,
        onSubmitted: @escaping (String) -> Void ) -> CareRequestViewModel {
            CareRequestViewModel(
                preselectedService: preselectedService,
                entryPoint: entryPoint,
                fetchAvailableServicesUseCase: FetchAvailableServicesUseCase(repository: careRequestRepository),
                fetchSavedAddressUseCase: FetchSavedAddressUseCase(repository: careRequestRepository),
                submitCareRequestUseCase: SubmitCareRequestUseCase(repository: careRequestRepository),
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
    
    func makeVisitCompletedViewModel(visitId: String) -> VisitCompletedViewModel {
        VisitCompletedViewModel(
            visitId: visitId,
            getVisitSummaryUseCase: makeGetVisitSummaryUseCase(),
            submitVisitRatingUseCase: makeSubmitVisitRatingUseCase()
        )
    }
    
    // MARK: - Search Offer Repository
    
    private lazy var offerSearchingRepository: OfferSearchingRepositoryProtocol = {
        OfferSearchingRepositoryImpl(hubService: OffersSearchingHubServices())
    }()
    
    // MARK: - Search Offer UseCases
    
    private func makeObserveOffersUseCase() -> ObserveOffersUseCase {
        ObserveOffersUseCase(repository: offerSearchingRepository)
    }
    
    private func makeManageOffersConnectionUseCase() -> ManageOffersConnectionUseCase {
        ManageOffersConnectionUseCase(repository: offerSearchingRepository)
    }
    
    // MARK: - Search Offer ViewModels
    
    func makeOffersSearchingViewModel(
        requestId: String,
        onOfferAccepted: @escaping (ConfirmedOffer)->Void,
        onShowNurseProfile: @escaping (String)->Void
    ) -> OffersSearchingViewModel {
        OffersSearchingViewModel(
            requestId: requestId,
            observeOffersUseCase: makeObserveOffersUseCase(),
            manageOffersConnectionUseCase: makeManageOffersConnectionUseCase(),
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
    
    // MARK: - AIAssistant Repository
    
    private lazy var aiPatientRepository: AIPatientRepositoryProtocol = MockAIPatientRepository()
    
    // MARK: - AIAssistant UseCases
    
    private func makeGetAIPatientsUseCase() -> GetAIPatientsUseCaseProtocol {
        GetAIPatientsUseCase(repository: aiPatientRepository)
    }
    
    // MARK: - AIAssistant ViewModels
    
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
}
