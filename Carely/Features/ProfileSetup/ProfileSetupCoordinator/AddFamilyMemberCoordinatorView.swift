//
//  AddFamilyMemberCoordinatorView.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 01/08/2026.
//


import SwiftUI

struct AddFamilyMemberCoordinatorView: View {
    let container: DIContainer
    let onFinish: () -> Void
    let onCancel: () -> Void

    @State private var coordinator: ProfileSetupCoordinator?

    var body: some View {
        Group {
            if let coordinator {
                ProfileSetupCoordinatorView(
                    coordinator: coordinator,
                    container: container,
                    mode: .editing(profileId: coordinator.profileId ?? ""),
                    onFinish: onFinish,
                    onBack: onCancel
                )
            } else {
                AddFamilyMemberInfoView(
                    viewModel: container.makeAddFamilyMemberInfoViewModel(
                        onCreated: { profileId in
                            let newCoordinator = container.makeProfileSetupCoordinator()
                            newCoordinator.setProfileId(profileId)
                            self.coordinator = newCoordinator
                        },
                        onBack: onCancel
                    )
                )
            }
        }
    }
}