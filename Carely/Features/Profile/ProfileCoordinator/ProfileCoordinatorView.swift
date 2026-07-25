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
            FamilyMembersView(viewModel: container.makeFamilyMembersViewModel(coordinator: coordinator))

        case .settings:
            SettingsView(viewModel: container.makeSettingsViewModel(coordinator: coordinator))
        }
    }
}
