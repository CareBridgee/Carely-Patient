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

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ProfileView(viewModel: container.makeProfileViewModel(coordinator: coordinator))
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
            let _ = { coordinator.onFamilyMembersViewModelCreated?(vm) }()
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
                onFinish: { coordinator.pop() }
            )

        case .address(let profileId):
            ProfileAddressView(
                viewModel: container.makeProfileAddressViewModel(profileId: profileId, coordinator: coordinator)
            )
        }
    }
}
