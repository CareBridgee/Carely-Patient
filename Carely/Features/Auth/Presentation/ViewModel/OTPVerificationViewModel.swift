//
//  OTPVerificationViewState.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//

import Foundation


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
    private let loginUseCase: LoginUseCaseProtocol
    private let router: AuthRouter
    
    let phoneNumber: String
    let pendingToken: String?
    let otpLength = 6
    private let onAuthFinished: () -> Void
    private let onGoToDecision: () -> Void
    
    @Published var otpCode: String = "" {
        didSet {
            if case .error = state, otpCode != oldValue {
                state = .idle
            }
        }
    }

    var successMessage: String? {
        if case .success(let message) = state { return message }
        return nil
    }
    
    @Published private(set) var state: OTPVerificationViewState = .idle

    var isOTPComplete: Bool {
        otpCode.count == otpLength && otpCode.allSatisfy(\.isNumber)
    }

    var isLoading: Bool { state == .loading }

    var isVerifyEnabled: Bool {
        if case .success = state { return false }
        return isOTPComplete && !isLoading
    }

    var errorMessage: String? {
        if case .error(let message) = state { return message }
        return nil
    }

    init(
        phoneNumber: String,
        devOTP: String? = nil,
        pendingToken: String? = nil,
        verifyOTPUseCase: VerifyOTPUseCaseProtocol,
        loginUseCase: LoginUseCaseProtocol,
        router: AuthRouter,
        onAuthFinished: @escaping () -> Void = {},
        onGoToDecision: @escaping () -> Void = {}
    ) {
        self.phoneNumber = phoneNumber
        self.pendingToken = pendingToken
        self.verifyOTPUseCase = verifyOTPUseCase
        self.loginUseCase = loginUseCase
        self.router = router
        self.onAuthFinished = onAuthFinished
        self.onGoToDecision = onGoToDecision
        if let devOTP = devOTP, !devOTP.isEmpty {
            self.otpCode = devOTP
        }
    }

    func verifyOTP() async {
        guard isOTPComplete, !isLoading else { return }
        state = .loading

        do {
            let result = try await verifyOTPUseCase.execute(phoneNumber: phoneNumber, otp: otpCode, pendingToken: pendingToken)
            state = .success("Phone verified successfully!")
            try await Task.sleep(nanoseconds: 800_000_000)
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

    func resendOTP() {
        Task {
            do {
                let response = try await loginUseCase.execute(phoneNumber: phoneNumber)
                self.otpCode = response.otp // Autofill new dev OTP
                state = .success("OTP Resent successfully!")
            } catch {
                state = .error("Failed to resend OTP.")
            }
        }
    }

    private func navigate(after result: OTPVerificationEntity) {
            if pendingToken != nil {
              
                onGoToDecision()
            } else if result.isNewUser {
                router.pushAsRoot(to: .PersonalInfo)
            } else {
                onAuthFinished()
            }
        }
    }

