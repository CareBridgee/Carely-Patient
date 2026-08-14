//
//  ProfileHealthViewModel.swift
//  Carely
//

import Foundation

@MainActor
final class ProfileHealthViewModel: ObservableObject {

    // MARK: - Form Fields
    @Published var heightText: String
    @Published var weightText: String
    @Published var bloodType: String
    @Published var mobilityStatus: String
    @Published var mobilityNotes: String
    @Published var previousSurgeries: String
    @Published var previousHospitalizations: String

    // MARK: - State
    @Published var isLoading = false
    @Published var isSaved  = false
    @Published var errorMessage: String? = nil
    @Published var showError = false

    // MARK: - Validation helpers
    var heightError: String? {
        guard !heightText.isEmpty else { return nil }
        guard let h = Double(heightText), h >= 50 && h <= 300 else { return "Height must be 50–300 cm" }
        return nil
    }
    var weightError: String? {
        guard !weightText.isEmpty else { return nil }
        guard let w = Double(weightText), w >= 2 && w <= 400 else { return "Weight must be 2–400 kg" }
        return nil
    }
    var isFormValid: Bool { heightError == nil && weightError == nil }

    private let profileId: String
    private let updateUseCase: UpdateProfileUseCaseProtocol
    private let coordinator: ProfileCoordinator

    // MARK: - Possible values for pickers
    static let bloodTypes = ["", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    static let mobilityOptions: [(label: String, value: String)] = [
        ("—", ""),
        ("Independent", "INDEPENDENT"),
        ("Partial Assistance", "PARTIAL_ASSISTANCE"),
        ("Total Assistance", "TOTAL_ASSISTANCE"),
        ("Wheelchair", "WHEELCHAIR"),
        ("Bedridden", "BEDRIDDEN")
    ]

    // MARK: - Init

    init(
        profileId: String,
        profile: PatientProfile?,
        updateUseCase: UpdateProfileUseCaseProtocol,
        coordinator: ProfileCoordinator
    ) {
        self.profileId     = profileId
        self.updateUseCase = updateUseCase
        self.coordinator   = coordinator

        // Pre-populate from existing profile data
        self.heightText               = profile?.height.map { h in h.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", h) : String(h) } ?? ""
        self.weightText               = profile?.weight.map { w in w.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", w) : String(w) } ?? ""
        self.bloodType                = profile?.bloodType ?? ""
        self.mobilityStatus           = profile?.mobilityStatus ?? ""
        self.mobilityNotes            = profile?.mobilityNotes ?? ""
        self.previousSurgeries        = profile?.previousSurgeries ?? ""
        self.previousHospitalizations = profile?.previousHospitalizations ?? ""
    }

    // MARK: - Save

    func saveTapped() {
        guard isFormValid else { return }

        let params = ProfileUpdateRequestParams(
            firstName: "",
            lastName: "",
            dateOfBirth: "",
            gender: "",
            relationship: "",
            bloodType: bloodType.isEmpty ? nil : bloodType,
            height: Double(heightText),
            weight: Double(weightText),
            mobilityStatus: mobilityStatus.isEmpty ? nil : mobilityStatus,
            mobilityNotes: mobilityNotes.isEmpty ? nil : mobilityNotes,
            previousSurgeries: previousSurgeries.isEmpty ? nil : previousSurgeries,
            previousHospitalizations: previousHospitalizations.isEmpty ? nil : previousHospitalizations,
            profileImageUrl: nil
        )

        isLoading = true
        errorMessage = nil

        Task {
            do {
                // ProfileNetworkService decides internally whether to also call PUT /users/me
                try await updateUseCase.execute(id: profileId, params: params, image: nil)
                isLoading = false
                isSaved   = true
            } catch {
                isLoading = false
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    // MARK: - Navigation

    func backTapped() { coordinator.pop() }
}
