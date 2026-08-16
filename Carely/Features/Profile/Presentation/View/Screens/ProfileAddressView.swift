//
//  ProfileAddressView.swift
//  Carely
//

import SwiftUI

struct ProfileAddressProfileOption: Identifiable, Hashable {
    let id: String
    let name: String
    let relation: String
}

@MainActor
final class ProfileAddressViewModel: ObservableObject {
    @Published var profiles: [ProfileAddressProfileOption] = []
    @Published var selectedProfileId: String
    @Published var isLoadingProfiles = false

    /// Drives the `.errorToast` when loading the profile/family member list
    /// for the address-picker tabs fails. Holds the exact server message.
    @Published var errorMessage: String? = nil

    let homeAddressViewModel: HomeAddressViewModel
    private let getPatientProfileUseCase: GetPatientProfileUseCaseProtocol
    private let getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol
    private let patientProfilesStore: PatientProfilesStore
    private let coordinator: ProfileCoordinator

    init(
        initialProfileId: String,
        homeAddressViewModel: HomeAddressViewModel,
        getPatientProfileUseCase: GetPatientProfileUseCaseProtocol,
        getFamilyMembersUseCase: GetFamilyMembersUseCaseProtocol,
        patientProfilesStore: PatientProfilesStore,
        coordinator: ProfileCoordinator
    ) {
        self.selectedProfileId = initialProfileId
        self.homeAddressViewModel = homeAddressViewModel
        self.getPatientProfileUseCase = getPatientProfileUseCase
        self.getFamilyMembersUseCase = getFamilyMembersUseCase
        self.patientProfilesStore = patientProfilesStore
        self.coordinator = coordinator
        populateFromStore()
    }

    func onAppear() {
        if profiles.isEmpty {
            loadProfiles()
        } else {
            loadAddressForSelectedProfile()
        }
    }

    private func populateFromStore() {
        var options: [ProfileAddressProfileOption] = []
        if let primary = patientProfilesStore.primaryProfile {
            options.append(ProfileAddressProfileOption(id: primary.id, name: primary.displayName, relation: "Primary"))
        }
        for m in patientProfilesStore.familyMembers {
            options.append(ProfileAddressProfileOption(id: m.id, name: m.name, relation: m.relation))
        }
        if !options.isEmpty {
            self.profiles = options
        }
    }

    func selectProfile(_ profileId: String) {
        guard selectedProfileId != profileId else { return }
        selectedProfileId = profileId
        loadAddressForSelectedProfile()
    }

    private func loadAddressForSelectedProfile() {
        if let cachedAddress = patientProfilesStore.addressesByProfileId[selectedProfileId] {
            homeAddressViewModel.applyAddress(cachedAddress)
        } else {
            homeAddressViewModel.loadAddress(profileId: selectedProfileId)
        }
    }

    func backTapped() {
        coordinator.pop()
    }

    private func loadProfiles() {
        isLoadingProfiles = true
        Task {
            do {
                async let primaryProfile = getPatientProfileUseCase.execute()
                async let familyMembers = getFamilyMembersUseCase.execute()

                let (primary, members) = try await (primaryProfile, familyMembers)

                var options: [ProfileAddressProfileOption] = [
                    ProfileAddressProfileOption(id: primary.id, name: primary.displayName, relation: "Primary")
                ]

                for m in members {
                    options.append(ProfileAddressProfileOption(id: m.id, name: m.name, relation: m.relation))
                }

                self.profiles = options
                self.isLoadingProfiles = false
                self.homeAddressViewModel.loadAddress(profileId: self.selectedProfileId)
            } catch {
                self.isLoadingProfiles = false
                self.errorMessage = error.carelyDescription
                self.homeAddressViewModel.loadAddress(profileId: self.selectedProfileId)
            }
        }
    }
}

struct ProfileAddressView: View {
    @StateObject private var viewModel: ProfileAddressViewModel

    init(viewModel: ProfileAddressViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.profiles.count > 1 {
                    profileSelector
                        .padding(.vertical, Spacing.s12)
                }

                HomeAddressView(viewModel: viewModel.homeAddressViewModel)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .careConnectNavigationBar(
            title: "Addresses",
            showBackButton: true,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .onAppear {
            viewModel.onAppear()
        }
        .errorToast($viewModel.errorMessage)
    }

    // MARK: - Profile Selector Tabs

    private var profileSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Spacing.s12) {
                ForEach(viewModel.profiles) { profile in
                    profileTab(for: profile)
                }
            }
            .padding(.horizontal, Spacing.s16)
        }
    }

    private func profileTab(for profile: ProfileAddressProfileOption) -> some View {
        let isSelected = profile.id == viewModel.selectedProfileId
        return Button {
            viewModel.selectProfile(profile.id)
        } label: {
            HStack(spacing: Spacing.s8) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "person.circle")
                    .font(.system(size: 14))
                Text(profile.name)
                    .carelyText(style: .bodySmall, weight: isSelected ? .bold : .medium)
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s8)
            .background(isSelected ? Color.brandPrimary : Color.surface)
            .foregroundColor(isSelected ? .onPrimary : .primaryFont)
            .clipShape(Capsule())
            .carelyShadow(.sm)
        }
        .buttonStyle(.plain)
    }
}
