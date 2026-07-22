//
//  AppContainer.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

// I will instantiate it once at the absolute highest point
@MainActor
final class DIContainer {
    
    // MARK: - Repositories
    
    private lazy var authRepository: AuthRepositoryProtocol = {
        AuthRepositoryImpl(
            // inject here your dataSources
        )
    }()
    
    // MARK: - Auth UseCases
    
    private func makeSavePersonalInfoUseCase() -> SavePersonalInfoUseCaseProtocol {
        SavePersonalInfoUseCase(repository: authRepository)
    }
    
    private func makeVerifyOTPUseCase() -> VerifyOTPUseCaseProtocol {
        VerifyOTPUseCase(repository: authRepository)
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
        PhoneNumberViewModel(router: router)
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
     
        func makeHomeViewModel() -> HomeViewModel {
            HomeViewModel(
                getGreetingNameUseCase: makeGetGreetingNameUseCase(),
                getServiceCategoriesUseCase: makeGetServiceCategoriesUseCase(),
                getUpcomingBookingsUseCase: makeGetUpcomingBookingsUseCase()
            )
        }
     
        func makeServiceCategoriesViewModel() -> ServiceCategoriesViewModel {
            ServiceCategoriesViewModel(
                getServiceCategoriesUseCase: makeGetServiceCategoriesUseCase(),
                searchServiceCategoriesUseCase: makeSearchServiceCategoriesUseCase()
            )
        }
     
        func makeServiceDetailsViewModel(serviceId: String) -> ServiceDetailsViewModel {
            ServiceDetailsViewModel(
                serviceId: serviceId,
                getServiceDetailUseCase: makeGetServiceDetailUseCase()
            )
        }
}

