//
//  PersonalInfoViewModel.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import Foundation
import Combine
import _PhotosUI_SwiftUI

@MainActor
final class PersonalInfoViewModel: ObservableObject {

    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date? = nil
    @Published var gender: Gender = .male

    @Published var photoSelection: PhotosPickerItem? {
        didSet { handlePhotoSelectionChange() }
    }
    @Published private(set) var profilePhotoData: Data?

    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var dobError: String? = nil

    @Published var isLoading: Bool = false
    @Published var apiErrorMessage: String? = nil
    @Published var showError: Bool = false

    private let savePersonalInfoUseCase: SavePersonalInfoUseCaseProtocol
    private let logoutUseCase: LogoutUseCaseProtocol?
    private let router: AuthRouter
    private var onOersonalDataSaved: () -> Void
    private var onLogout: (() -> Void)?

    init(
        savePersonalInfoUseCase: SavePersonalInfoUseCaseProtocol,
        logoutUseCase: LogoutUseCaseProtocol? = nil,
        router: AuthRouter,
        onOersonalDataSaved: @escaping () -> Void,
        onLogout: (() -> Void)? = nil
    ) {
        self.savePersonalInfoUseCase = savePersonalInfoUseCase
        self.logoutUseCase = logoutUseCase
        self.router = router
        self.onOersonalDataSaved = onOersonalDataSaved
        self.onLogout = onLogout
    }

    @Published var showLogoutConfirmation: Bool = false

    func logoutTapped() {
        showLogoutConfirmation = true
    }

    func confirmLogout() {
        Task {
            do {
                try await logoutUseCase?.execute()
            } catch {
                print("Failed to logout: \(error.localizedDescription)")
            }
            onLogout?()
        }
    }

    func continueTapped() {
        guard validateInputs() else { return }
        guard NetworkMonitor.shared.isConnected else {
            apiErrorMessage = "No internet connection. Please check your network."
            showError = true
            return
        }

        isLoading = true
        apiErrorMessage = nil

        let basicInfo = BasicUserInfo(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            secondName: lastName.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dateOfBirth ?? Date(),
            Gender: gender,
            profileImage: profilePhotoData.flatMap { UIImage(data: $0) }
        )

        Task {
            do {
                try await self.savePersonalInfoUseCase.execute(basicInfo: basicInfo)
                isLoading = false
                onOersonalDataSaved()
            } catch {
                isLoading = false
                apiErrorMessage = error.localizedDescription
                showError = true
            }
        }
    }

    // MARK: - Photo

    private func handlePhotoSelectionChange() {
        guard let item = photoSelection else {
            profilePhotoData = nil
            return
        }
        Task {
            do {
                guard let data = try await item.loadTransferable(type: Data.self) else {
                    throw PhotoLoadError.unsupported
                }
                profilePhotoData = data
            } catch {
                apiErrorMessage = "We couldn't load that photo. Please try a different one."
                showError = true
            }
        }
    }

    private var imageFileExtension: String {
        guard let data = profilePhotoData, data.starts(with: [0x89, 0x50, 0x4E, 0x47] as [UInt8]) else { return "jpg" }
        return "png"
    }

    private var imageMimeType: String {
        guard let data = profilePhotoData, data.starts(with: [0x89, 0x50, 0x4E, 0x47] as [UInt8]) else { return "image/jpeg" }
        return "image/png"
    }

    private enum PhotoLoadError: Error { case unsupported }

    // MARK: - Validation
    private func validateInputs() -> Bool {
        var isValid = true
        firstNameError = nil; lastNameError = nil; dobError = nil; apiErrorMessage = nil

        if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
            firstNameError = "First name is required"; isValid = false
        }
        if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
            lastNameError = "Last name is required"; isValid = false
        }
        if let dob = dateOfBirth {
            if let age = Calendar.current.dateComponents([.year], from: dob, to: Date()).year, age < 18 {
                dobError = "You must be +18 to use CareConnect"; isValid = false
            }
        } else {
            dobError = "Date of birth is required"; isValid = false
        }
        return isValid
    }
}
