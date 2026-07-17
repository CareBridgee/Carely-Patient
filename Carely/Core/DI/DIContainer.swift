//
//  AppContainer.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

// I will instantiate it once at the absolute highest pointz
@MainActor
final class DIContainer{
    
    private lazy var authRepository : AuthRepositoryProtocol = {
        AuthRepositoryImpl(
        // inject here your dataSources
        )
    }()
    
    private func makeSavePersonalInfoUseCase() -> SavePersonalInfoUseCaseProtocol{
        SavePersonalInfoUseCase(
            repository: authRepository
        )
    }
    
    private func makeVerifyOTPUseCase() -> VerifyOTPUseCaseProtocol {
        VerifyOTPUseCase(repository: authRepository)
    }

  
    //TODO: inject your UseCases here
//    func makeWelcomViewModel(router: AuthRouter) -> WelcomeViewModel{
//        WelcomeViewModel(router: router)
//    }
    
//    func makePhoneNumberViewModel(router: AuthRouter) -> PhoneNumberViewModel{
//        PhoneNumberViewModel(router: router)
//    }
    
    func makeOTPVerificationViewModel(phoneNumber: String, router: AuthRouter, onAuthFinished: @escaping () -> Void) -> OTPVerificationViewModel {
        OTPVerificationViewModel(
            phoneNumber: phoneNumber,
            verifyOTPUseCase: makeVerifyOTPUseCase(),
            router: router,
            onAuthFinished: onAuthFinished
        )
    }
    
    func makePersonalInfoViewModel( router: AuthRouter) -> PersonalInfoViewModel {
        return PersonalInfoViewModel(
            savePersonalInfoUseCase: makeSavePersonalInfoUseCase(),
            router: router
        )
    }
//
//    func makeProfileSetupDecisionViewModel(router: AuthRouter) -> ProfileSetupDecisionViewModel{
//        ProfileSetupDecisionViewModel(router: router)
//    }
}
