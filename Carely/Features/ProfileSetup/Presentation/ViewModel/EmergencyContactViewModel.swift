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

    // MARK: - Validation & Network State
    @Published private(set) var contactNameError: String?
    @Published private(set) var relationshipError: String?
    @Published private(set) var phoneNumberError: String?
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false

    // MARK: - Dependencies
    private let getProfileIdUseCase: GetDefaultProfileIdUseCase
    private let saveContactUseCase: SaveEmergencyContactUseCase
    private let overrideProfileId: String?

    private let onContinue: (EmergencyContact) -> Void
    private let onBack: (EmergencyContact) -> Void

    init(
        initialContact: EmergencyContact?,
        getProfileIdUseCase: GetDefaultProfileIdUseCase,
        saveContactUseCase: SaveEmergencyContactUseCase,
        overrideProfileId: String? = nil,
        onContinue: @escaping (EmergencyContact) -> Void,
        onBack: @escaping (EmergencyContact) -> Void
    ) {
        self.contactName = initialContact?.name ?? ""
        self.relationship = initialContact?.relationship ?? ""
        self.phoneNumber = initialContact?.phoneNumber ?? ""
        self.getProfileIdUseCase = getProfileIdUseCase
        self.saveContactUseCase = saveContactUseCase
        self.overrideProfileId = overrideProfileId
        self.onContinue = onContinue
        self.onBack = onBack
    }

    // MARK: - Derived State
    
    private var contact: EmergencyContact {
        EmergencyContact(name: contactName.trimmed, phoneNumber: phoneNumber.trimmed, relationship: relationship.trimmed)
    }

    var isEmpty: Bool {
        contactName.trimmed.isEmpty && relationship.trimmed.isEmpty && phoneNumber.trimmed.isEmpty
    }

    var isValid: Bool {
        !contactName.trimmed.isEmpty && !relationship.trimmed.isEmpty && isValidPhoneNumber(phoneNumber)
    }

    // MARK: - Actions

    func backTapped() {
        onBack(contact)
    }

    func continueTapped() {
        // MARK: - SKIP LOGIC
        if isEmpty {
            onContinue(contact)
            return
        }

        // MARK: - VALIDATION LOGIC (If not skipping)
        validateAll()
        guard isValid else { return }

        // MARK: - NETWORK LOGIC
        guard NetworkMonitor.shared.isConnected else {
            self.errorMessage = "No internet connection. Please check your network."
            self.showError = true
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId: String
                if let overrideProfileId {
                    profileId = overrideProfileId
                } else {
                    profileId = try await getProfileIdUseCase.execute()
                }
                try await saveContactUseCase.execute(profileId: profileId, contact: contact)
                
                self.isLoading = false
                self.onContinue(contact)
                
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }

    private func validateAll() {
        contactNameError = contactName.trimmed.isEmpty ? "Contact name is required." : nil
        relationshipError = relationship.trimmed.isEmpty ? "Relationship is required." : nil
        phoneNumberError = isValidPhoneNumber(phoneNumber) ? nil : "Enter a valid phone number."
    }

    private func isValidPhoneNumber(_ value: String) -> Bool {
        let digits = value.filter(\.isNumber)
        return digits.count >= 10
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
