//
//  EmergencyContactViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class EmergencyContactViewModel: ObservableObject {

    // MARK: - Input State

    @Published var contactName: String
    @Published var relationship: String
    @Published var phoneNumber: String

    // MARK: - Validation State

    @Published private(set) var contactNameError: String?
    @Published private(set) var relationshipError: String?
    @Published private(set) var phoneNumberError: String?

    // MARK: - Dependencies

    private let onContinue: (EmergencyContact) -> Void
    private let onBack: () -> Void

    // MARK: - Init

    init(
        initialContact: EmergencyContact?,
        onContinue: @escaping (EmergencyContact) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.contactName = initialContact?.name ?? ""
        self.relationship = initialContact?.relationship ?? ""
        self.phoneNumber = initialContact?.phoneNumber ?? ""
        self.onContinue = onContinue
        self.onBack = onBack
    }

    // MARK: - Derived State

    var isValid: Bool {
        !contactName.trimmed.isEmpty
            && !relationship.trimmed.isEmpty
            && isValidPhoneNumber(phoneNumber)
    }

    // MARK: - Actions

    func continueTapped() {
        validateAll()
        guard isValid else { return }

        let contact = EmergencyContact(
            name: contactName.trimmed,
            phoneNumber: phoneNumber.trimmed,
            relationship: relationship.trimmed
        )
        onContinue(contact)
    }

    func backTapped() {
        onBack()
    }

    // MARK: - Validation

    private func validateAll() {
        contactNameError = contactName.trimmed.isEmpty
            ? "Contact name is required."
            : nil

        relationshipError = relationship.trimmed.isEmpty
            ? "Relationship is required."
            : nil

        phoneNumberError = isValidPhoneNumber(phoneNumber)
            ? nil
            : "Enter a valid phone number."
    }

    private func isValidPhoneNumber(_ value: String) -> Bool {
        let digits = value.filter(\.isNumber)
        return digits.count >= 10
    }
}

// MARK: - String + Trimmed

private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
