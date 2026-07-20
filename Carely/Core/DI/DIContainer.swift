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
        MobilityViewModel(coordinator: coordinator)
    }
}
