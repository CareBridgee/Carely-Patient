//
//  ProfileCoordinatorView.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI
 
struct ProfileCoordinatorView: View {
 
    let container: DIContainer
    @ObservedObject var coordinator: ProfileCoordinator
    @StateObject private var profileViewModel: ProfileViewModel
 
    init(container: DIContainer, coordinator: ProfileCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _profileViewModel = StateObject(wrappedValue: container.makeProfileViewModel(coordinator: coordinator))
    }
 
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ProfileView(viewModel: profileViewModel)
                .navigationDestination(for: ProfileRoute.self) { route in
                    destination(for: route)
                }
        }
    }
 
    @ViewBuilder
    private func destination(for route: ProfileRoute) -> some View {
        switch route {
        case .familyMembers:
            let vm = container.makeFamilyMembersViewModel(coordinator: coordinator)
            FamilyMembersView(viewModel: vm)
 
        case .settings:
            SettingsView(viewModel: container.makeSettingsViewModel(coordinator: coordinator))
 
        case .personalInfo(let profileId), .editMemberPersonalInfo(let profileId):
            ProfilePersonalInfoView(
                viewModel: container.makeProfilePersonalInfoViewModel(profileId: profileId, coordinator: coordinator)
            )
 
        case .healthProfile(let profileId), .editMemberHealthProfile(let profileId):
            ProfileSetupCoordinatorView(
                coordinator: container.makeProfileHealthSetupCoordinator(profileId: profileId),
                container: container,
                mode: .editing(profileId: profileId),
                onFinish: { coordinator.pop() },
                onBack: { coordinator.pop() }
            )
 
        case .address(let profileId):
            ProfileAddressView(
                viewModel: container.makeProfileAddressViewModel(profileId: profileId, coordinator: coordinator)
            )
 
        case .wallet:
            WalletView(viewModel: container.makeWalletViewModel(coordinator: coordinator))
 
        case .topUp(let userId):
            TopUpWalletView(
                viewModel: container.makeTopUpViewModel(userId: userId, coordinator: coordinator)
            )
        }
    }
}
