//
//  EmergencyContactViewModel.swift
//  Carely
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
    private var existingContactId: String?
    private var initialContactData: EmergencyContact
    private let getProfileIdUseCase: GetDefaultProfileIdUseCase?
    private let fetchContactUseCase: FetchEmergencyContactUseCase?
    private let saveContactUseCase: SaveEmergencyContactUseCase?
    private let overrideProfileId: String?

    private let onContinue: (EmergencyContact) -> Void
    private let onBack: (EmergencyContact) -> Void

    init(
        initialContact: EmergencyContact?,
        getProfileIdUseCase: GetDefaultProfileIdUseCase? = nil,
        fetchContactUseCase: FetchEmergencyContactUseCase? = nil,
        saveContactUseCase: SaveEmergencyContactUseCase? = nil,
        overrideProfileId: String? = nil,
        onContinue: @escaping (EmergencyContact) -> Void,
        onBack: @escaping (EmergencyContact) -> Void
    ) {
        let id = initialContact?.id
        let name = initialContact?.name ?? ""
        let rel = initialContact?.relationship ?? ""
        let phone = initialContact?.phoneNumber ?? ""
        self.existingContactId = id
        self.contactName = name
        self.relationship = rel
        self.phoneNumber = phone
        self.initialContactData = EmergencyContact(id: id, name: name.trimmed, phoneNumber: phone.trimmed, relationship: rel.trimmed)
        self.getProfileIdUseCase = getProfileIdUseCase
        self.fetchContactUseCase = fetchContactUseCase
        self.saveContactUseCase = saveContactUseCase
        self.overrideProfileId = overrideProfileId
        self.onContinue = onContinue
        self.onBack = onBack
    }

    func onAppear() {
        guard let fetchUseCase = fetchContactUseCase else { return }
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId = try await resolveProfileId()
                if let loaded = try await fetchUseCase.execute(profileId: profileId) {
                    self.existingContactId = loaded.id
                    self.contactName = loaded.name
                    self.relationship = loaded.relationship
                    self.phoneNumber = loaded.phoneNumber
                    self.initialContactData = loaded
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
            }
        }
    }

    // MARK: - Derived State

    private var contact: EmergencyContact {
        EmergencyContact(id: existingContactId, name: contactName.trimmed, phoneNumber: phoneNumber.trimmed, relationship: relationship.trimmed)
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
        // MARK: - SKIP LOGIC (If contact unchanged or empty)
        if contact == initialContactData || isEmpty {
            onContinue(contact)
            return
        }

        // MARK: - VALIDATION LOGIC
        validateAll()
        guard isValid else { return }

        // MARK: - NETWORK LOGIC
        guard let saveUseCase = saveContactUseCase else {
            initialContactData = contact
            onContinue(contact)
            return
        }

        guard NetworkMonitor.shared.isConnected else {
            self.errorMessage = "No internet connection. Please check your network."
            self.showError = true
            return
        }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let profileId = try await resolveProfileId()
                try await saveUseCase.execute(profileId: profileId, contact: contact)

                self.initialContactData = self.contact
                self.isLoading = false
                self.onContinue(self.contact)
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }

    private func resolveProfileId() async throws -> String {
        if let overrideProfileId, !overrideProfileId.isEmpty {
            return overrideProfileId
        } else if let getProfileIdUseCase {
            return try await getProfileIdUseCase.execute()
        }
        return ""
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
