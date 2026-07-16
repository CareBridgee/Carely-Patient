//
//  OTPVerificationViewState.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//

import Foundation


enum OTPVerificationViewState: Equatable {
    case idle
    case loading
    case success(String)
    case error(String)
}

@MainActor
final class OTPVerificationViewModel: ObservableObject {
    private let verifyOTPUseCase: VerifyOTPUseCaseProtocol
    private let router: AuthRouter
    let phoneNumber: String
    let otpLength = 4
    private let onAuthFinished: () -> Void
    
    @Published var otpCode: String = "" {
        didSet {
            if case .error = state, otpCode != oldValue {
                state = .idle
            }
        }
    }

    var successMessage: String? {
            if case .success(let message) = state {
                return message
            }
            return nil
        }
    @Published private(set) var state: OTPVerificationViewState = .idle


    var isOTPComplete: Bool {
        otpCode.count == otpLength
    }

    var isLoading: Bool {
        state == .loading
    }

    var isVerifyEnabled: Bool {
            if case .success = state {
                return false
            }
            
            return isOTPComplete && !isLoading
        }

    var errorMessage: String? {
        if case .error(let message) = state {
            return message
        }
        return nil
    }

    init(
        phoneNumber: String,
        verifyOTPUseCase: VerifyOTPUseCaseProtocol,
        router: AuthRouter,
        onAuthFinished: @escaping () -> Void = {}
    ) {
        self.phoneNumber = phoneNumber
        self.verifyOTPUseCase = verifyOTPUseCase
        self.router = router
        self.onAuthFinished = onAuthFinished
    }

    func verifyOTP() async {
        guard isOTPComplete, !isLoading else { return }

        state = .loading

        do {
            let result = try await verifyOTPUseCase.execute(phoneNumber: phoneNumber, otp: otpCode)
            state = .success("Phone verified successfully!")
            try await Task.sleep(nanoseconds: 1_200_000_000)
            navigate(after: result)
        } catch let error as AuthError {
            state = .error(error.errorDescription ?? AuthError.unknown.errorDescription!)
        } catch {
            state = .error(AuthError.unknown.errorDescription!)
        }
    }

    func goBack() {
        router.pop()
    }


    private func navigate(after result: OTPVerificationEntity) {
        if result.isNewUser {
            router.push(to: .PersonalInfo)
        } else {
            onAuthFinished()
        }
    }
}
