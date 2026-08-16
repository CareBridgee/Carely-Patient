//
//  PhoneNumberViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI
import Combine

@MainActor
final class PhoneNumberViewModel: ObservableObject {
    private let router: AuthRouter
    private let loginUseCase: LoginUseCaseProtocol

    @Published var phoneNumber: String = ""
    @Published private(set) var isPhoneNumberValid: Bool = false
    @Published private(set) var showPhoneNumberError: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    let pendingToken: String?
    
    private static let validPrefixes = ["10", "11", "12", "15"]
    private static let requiredDigitCount = 10

    /// Raw digit count once a local-format leading "0" is included
    /// (e.g. "01012345678"). Once input reaches this length and starts
    /// with "0", the leading zero is stripped automatically.
    private static let localFormatDigitCount = 11

    init(
        pendingToken: String?,
        loginUseCase: LoginUseCaseProtocol,
        router: AuthRouter
    ) {
        self.pendingToken = pendingToken
        self.loginUseCase = loginUseCase
        self.router = router
        setupValidation()
    }

    func phoneNumberChanged(_ newValue: String) {
        var digitsOnly = newValue.filter(\.isNumber)

        // Local-format numbers are typed with a leading "0" (e.g.
        // "01012345678"). Once 11+ digits have been entered and the first
        // is "0", drop it automatically — only the 10-digit number should
        // remain, since the "+20" country code is shown/applied separately.
        if digitsOnly.count >= Self.localFormatDigitCount, digitsOnly.first == "0" {
            digitsOnly.removeFirst()
        }

        let limited = String(digitsOnly.prefix(Self.requiredDigitCount))
        if limited != phoneNumber {
            phoneNumber = limited
        }
    }

    func phoneNumberFieldFocusChanged(isFocused: Bool) {
        // Validation is now driven live by every keystroke (see
        // setupValidation()), not by focus/unfocus — kept as a hook in
        // case future UX wants focus-specific behavior.
    }

    func nextButtonPressed() {
        let fullPhone = "+20" + phoneNumber
        errorMessage = nil
        isLoading = true
        Task {
            do {
                let response = try await loginUseCase.execute(phoneNumber: fullPhone)
                isLoading = false

                router.push(to: .OTPVerification(
                    phoneNumber: fullPhone,
                    devOTP: response.otp,
                    pendingToken: self.pendingToken
                ))
            } catch {
                isLoading = false
                errorMessage = error.carelyDescription
            }
        }
    }

    /// Emits live as the person types — validity and the error banner both
    /// update on every keystroke instead of waiting for the field to lose
    /// focus.
    private func setupValidation() {
        $phoneNumber
            .map { text in (text, Self.isValidPhoneNumber(text)) }
            .sink { [weak self] text, valid in
                self?.isPhoneNumberValid = valid
                self?.showPhoneNumberError = !valid && !text.isEmpty
            }
            .store(in: &cancellables)
    }

    private static func isValidPhoneNumber(_ number: String) -> Bool {
        let digits = number.filter(\.isNumber)
        guard digits.count == requiredDigitCount else { return false }
        return validPrefixes.contains { digits.hasPrefix($0) }
    }
}
