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
    @Published var existingImageUrl: URL?

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
    private var existingRelationship: String?

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
        self.existingRelationship = profile?.relationship

        let user = sessionManager.currentUser
        let isPrimaryUser = (user?.defaultProfileId == profileId)

        // Pre-populate from session cache ONLY if editing the primary profile
        let fName = (isPrimaryUser ? user?.firstName : nil) ?? profile?.firstName ?? ""
        let lName = (isPrimaryUser ? user?.lastName : nil)  ?? profile?.lastName  ?? ""
        self.firstName = fName
        self.lastName  = lName
        self.initialFirstName = fName
        self.initialLastName  = lName

        // Parse dateOfBirth string → Date
        let dobString = (isPrimaryUser ? user?.dateOfBirth : nil) ?? profile?.dateOfBirth
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
        let genderStr = (isPrimaryUser ? user?.gender : nil) ?? profile?.gender ?? ""
        let g = Gender(rawValue: genderStr) ?? .male
        self.gender = g
        self.initialGender = g

        // Existing image URL
        let imageUrlStr = (isPrimaryUser ? user?.profileImageUrl : nil) ?? profile?.profileImageUrl
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

                    if let rel = match.relationship, !rel.isEmpty {
                        self.existingRelationship = rel
                    }

                    if let imgStr = match.profileImageUrl, !imgStr.isEmpty {
                        self.existingImageUrl = URL(string: imgStr)
                    }
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
        let isPrimaryUser = (sessionManager.currentUser?.defaultProfileId == profileId)
        let relationshipStr = isPrimaryUser ? "SELF" : (existingRelationship ?? "")

        let params = ProfileUpdateRequestParams(
            firstName: trimmedFirst,
            lastName: trimmedLast,
            dateOfBirth: dobStr,
            gender: gender.rawValue,
            relationship: relationshipStr,
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
                // ProfileNetworkService decides internally whether to also call PUT /users/me
                try await updateUseCase.execute(id: profileId, params: params, image: selectedImage)

                // Update local session cache if editing the primary profile
                if isPrimaryUser, var user = sessionManager.currentUser {
                    user.firstName   = params.firstName
                    user.lastName    = params.lastName
                    user.gender      = params.gender
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
