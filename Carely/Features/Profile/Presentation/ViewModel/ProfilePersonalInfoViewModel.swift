//
//  ProfilePersonalInfoViewModel.swift
//  Carely
//

import Foundation
import UIKit
import _PhotosUI_SwiftUI

@MainActor
final class ProfilePersonalInfoViewModel: ObservableObject {

    // MARK: - Form Fields
    @Published var firstName: String
    @Published var lastName: String
    @Published var dateOfBirth: Date?
    @Published var gender: Gender

    @Published var photoSelection: PhotosPickerItem? {
        didSet { loadSelectedPhoto() }
    }
    @Published private(set) var selectedImage: UIImage?
    /// URL of the existing remote image (shown when no new photo is chosen)
    let existingImageUrl: URL?

    // MARK: - State
    @Published var isLoading = false
    @Published var isSaved  = false
    @Published var errorMessage: String? = nil
    @Published var showError = false

    // MARK: - Validation
    var firstNameError: String? { firstName.trimmingCharacters(in: .whitespaces).isEmpty ? "Required" : nil }
    var lastNameError: String?  { lastName.trimmingCharacters(in: .whitespaces).isEmpty  ? "Required" : nil }
    var isFormValid: Bool       { firstNameError == nil && lastNameError == nil }

    private let profileId: String
    private let updateUseCase: UpdateProfileUseCaseProtocol
    private let sessionManager: SessionManager
    private let coordinator: ProfileCoordinator
    private let networkService: ProfileNetworkServiceProtocol?

    private var initialFirstName: String
    private var initialLastName: String
    private var initialDateOfBirth: Date?
    private var initialGender: Gender

    // MARK: - Init

    init(
        profileId: String,
        profile: PatientProfile?,
        sessionManager: SessionManager,
        updateUseCase: UpdateProfileUseCaseProtocol,
        coordinator: ProfileCoordinator,
        networkService: ProfileNetworkServiceProtocol? = nil
    ) {
        self.profileId      = profileId
        self.updateUseCase  = updateUseCase
        self.sessionManager = sessionManager
        self.coordinator    = coordinator
        self.networkService = networkService

        // Pre-populate from session cache first, then API profile
        let user = sessionManager.currentUser
        let fName = user?.firstName ?? profile?.firstName ?? ""
        let lName = user?.lastName  ?? profile?.lastName  ?? ""
        self.firstName = fName
        self.lastName  = lName
        self.initialFirstName = fName
        self.initialLastName  = lName

        // Parse dateOfBirth string → Date
        let dobString = user?.dateOfBirth ?? profile?.dateOfBirth
        if let s = dobString {
            let fmt = ISO8601DateFormatter()
            fmt.formatOptions = [.withFullDate]
            let parsed = fmt.date(from: s)
            self.dateOfBirth = parsed
            self.initialDateOfBirth = parsed
        } else {
            self.dateOfBirth = nil
            self.initialDateOfBirth = nil
        }

        // Gender
        let genderStr = user?.gender ?? profile?.gender ?? ""
        let g = Gender(rawValue: genderStr) ?? .male
        self.gender = g
        self.initialGender = g

        // Existing image URL
        let imageUrlStr = user?.profileImageUrl ?? profile?.profileImageUrl
        self.existingImageUrl = imageUrlStr.flatMap(URL.init)
    }

    func onAppear() {
        guard let service = networkService else { return }
        Task {
            do {
                let all = try await service.fetchAllProfiles()
                if let match = all.first(where: { $0.id == profileId }) {
                    let fName = match.firstName ?? ""
                    let lName = match.lastName  ?? ""
                    self.firstName = fName
                    self.lastName  = lName
                    self.initialFirstName = fName
                    self.initialLastName  = lName

                    if let dobString = match.dateOfBirth {
                        let fmt = ISO8601DateFormatter()
                        fmt.formatOptions = [.withFullDate]
                        let parsed = fmt.date(from: dobString)
                        self.dateOfBirth = parsed
                        self.initialDateOfBirth = parsed
                    }

                    let g = Gender(rawValue: match.gender ?? "") ?? .male
                    self.gender = g
                    self.initialGender = g
                }
            } catch {
                // Keep default
            }
        }
    }

    // MARK: - Save

    func saveTapped() {
        guard isFormValid else { return }

        let trimmedFirst = firstName.trimmingCharacters(in: .whitespaces)
        let trimmedLast = lastName.trimmingCharacters(in: .whitespaces)
        let isUnchanged = (trimmedFirst == initialFirstName.trimmingCharacters(in: .whitespaces)) &&
                          (trimmedLast == initialLastName.trimmingCharacters(in: .whitespaces)) &&
                          (dateOfBirth == initialDateOfBirth) &&
                          (gender == initialGender) &&
                          (selectedImage == nil)

        if isUnchanged {
            isSaved = true
            return
        }

        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        let dobStr = dateOfBirth.map { formatter.string(from: $0) } ?? ""

        let params = ProfileUpdateRequestParams(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            lastName: lastName.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dobStr,
            gender: gender.rawValue,
            relationship: "SELF",
            bloodType: nil,
            height: nil,
            weight: nil,
            mobilityStatus: nil,
            mobilityNotes: nil,
            previousSurgeries: nil,
            previousHospitalizations: nil,
            profileImageUrl: nil
        )

        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await updateUseCase.execute(id: profileId, params: params, image: selectedImage)

                // Update session cache so profile image & name refresh everywhere instantly
                if var user = sessionManager.currentUser {
                    user.firstName = params.firstName
                    user.lastName  = params.lastName
                    user.gender    = params.gender
                    user.dateOfBirth = dobStr
                    sessionManager.updateUser(user)
                }

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

    // MARK: - Photo

    private func loadSelectedPhoto() {
        guard let item = photoSelection else { selectedImage = nil; return }
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else { return }
                selectedImage = UIImage(data: data)
            } catch {
                errorMessage = "Couldn't load that photo."
                showError = true
            }
        }
    }
}
