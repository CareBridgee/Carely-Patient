//
//  AddFamilyMemberInfoViewModel.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import Foundation

@MainActor
final class AddFamilyMemberInfoViewModel: ObservableObject {
    @Published var relationship: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date? = nil
    @Published var gender: Gender = .male

    @Published var relationshipError: String? = nil
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var dobError: String? = nil

    @Published var isLoading: Bool = false
    @Published var apiErrorMessage: String? = nil
    @Published var showError: Bool = false

    private let createFamilyMemberProfileUseCase: CreateFamilyMemberProfileUseCase
    private let onCreated: (String) -> Void   // newly created profileId
    private let onBack: () -> Void

    init(
        createFamilyMemberProfileUseCase: CreateFamilyMemberProfileUseCase,
        onCreated: @escaping (String) -> Void,
        onBack: @escaping () -> Void
    ) {
        self.createFamilyMemberProfileUseCase = createFamilyMemberProfileUseCase
        self.onCreated = onCreated
        self.onBack = onBack
    }

    func backTapped() { onBack() }

    func continueTapped() {
        guard validateInputs() else { return }
        guard NetworkMonitor.shared.isConnected else {
            apiErrorMessage = "No internet connection. Please check your network."
            showError = true
            return
        }

        isLoading = true
        apiErrorMessage = nil

        let info = FamilyMemberBasicInfo(
            relationship: relationship.trimmingCharacters(in: .whitespaces),
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dateOfBirth ?? Date(),
            gender: gender
        )

        Task {
            do {
                let profileId = try await createFamilyMemberProfileUseCase.execute(info)
                isLoading = false
                onCreated(profileId)
            } catch {
                isLoading = false
                apiErrorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    private func validateInputs() -> Bool {
        var isValid = true
        relationshipError = nil; firstNameError = nil; lastNameError = nil; dobError = nil; apiErrorMessage = nil

        if relationship.trimmingCharacters(in: .whitespaces).isEmpty {
            relationshipError = "Relationship is required"; isValid = false
        }
        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            firstNameError = "First name is required"; isValid = false
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            lastNameError = "Last name is required"; isValid = false
        }
        if let dob = dateOfBirth {
            if dob > Date() {
                dobError = "Date of birth can't be in the future"; isValid = false
            }
        } else {
            dobError = "Date of birth is required"; isValid = false
        }
        return isValid
    }
}