//
//  AIAssistantCoordinatorView.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import SwiftUI

struct AIAssistantCoordinatorView: View {
    let container: DIContainer
    @ObservedObject var coordinator: AIAssistantCoordinator
    @StateObject private var choosePatientViewModel: ChoosePatientViewModel

    init(container: DIContainer, coordinator: AIAssistantCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _choosePatientViewModel = StateObject(wrappedValue: container.makeChoosePatientViewModel(
            onShowPatientDetails: { patientId in
                coordinator.viewProfiledetailsTapped(profileId: patientId)
            },
            onContinueWithAssessment: { patientId in
                coordinator.push(to: .aiAssistantChat(patientId: patientId))
            },
            onAddFamilyMember: {
                coordinator.addFamilyMemberTapped()
            },
            onDismiss: {
                coordinator.onBackClicked?()
            }
        ))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ChoosePatientView(viewModel: choosePatientViewModel)
            .navigationDestination(for: AIAssistantRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AIAssistantRoute) -> some View {
        switch route {
        case .aiAssistantChat(let patientId):
            AIChatView(
                viewModel: container.makeAIChatViewModel(
                    profileId: patientId,
                    coordinator: coordinator
                )
            )
        case .addFamilyMember:
            AddFamilyMemberCoordinatorView(
                container: container,
                onFinish: {
                    coordinator.pop()
                },
                onCancel: {
                    coordinator.pop()
                }
            )
        }
    }
}

//
//#Preview {
//    AIAssistantCoordinatorView(container: <#DIContainer#>, coordinator: <#AIAssistantCoordinator#>)
//}
