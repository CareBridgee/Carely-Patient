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

    @Published var phoneNumber: String = ""
    @Published private(set) var isPhoneNumberValid: Bool = false
    @Published private(set) var showPhoneNumberError: Bool = false

    private let unfocusTrigger = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    private static let validPrefixes = ["10", "11", "12", "15"]
    private static let requiredDigitCount = 10

    init(router: AuthRouter) {
        self.router = router
        setupValidation()
    }

    func phoneNumberChanged(_ newValue: String) {
        let digitsOnly = newValue.filter(\.isNumber)
        let limited = String(digitsOnly.prefix(Self.requiredDigitCount))
        if limited != phoneNumber {
            phoneNumber = limited
        }
    }

    func phoneNumberFieldFocusChanged(isFocused: Bool) {
        if isFocused {
            showPhoneNumberError = false
        } else {
            unfocusTrigger.send(phoneNumber)
        }
    }

    func nextButtonPressed(){
        router.push(to: .OTPVerification(phoneNumber: phoneNumber))
    }

    private func setupValidation() {
        unfocusTrigger
            .debounce(for: .milliseconds(150), scheduler: DispatchQueue.main)
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
