//
//  HomeCoordinatorView.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import SwiftUI

// MARK: - HomeCoordinatorView

struct HomeCoordinatorView: View {

    let container: DIContainer
    @ObservedObject var coordinator: HomeCoordinator
    @StateObject private var homeViewModel: HomeViewModel

    init(container: DIContainer, coordinator: HomeCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _homeViewModel = StateObject(wrappedValue: container.makeHomeViewModel(
            onServiceTabbed: coordinator.serviceTapped,
            onSeeAllHistory: coordinator.seeAllHistoryTapped,
            onOpenActiveVisit: coordinator.activeVisitTapped,
            onViewAllServices: coordinator.viewAllServicesTapped,
            onOpenAIAssistant: coordinator.aiBannerTapped
        ))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            HomeView(viewModel: homeViewModel)
                .navigationDestination(for: HomeRoute.self) { route in
                    destination(for: route)
                }
        }
    }

    @ViewBuilder
    private func destination(for route: HomeRoute) -> some View {
        switch route {
        case .choosePatient:
            ChoosePatientView(
                viewModel: container.makeChoosePatientViewModel(
                    onContinueWithAssessment: { patientId in
                        coordinator.push(to: .aiChat(patientId: patientId))
                    },
                    onAddFamilyMember: {
                        coordinator.push(to: .addFamilyMember)
                    }
                ),
                onBackTapped: {
                    coordinator.pop()
                }
            )
        case .aiChat(let patientId):
            AIChatView(
                viewModel: container.makeAIChatViewModel(
                    profileId: patientId,
                    onProceedToBooking: { draft in
                        coordinator.popToRoot()
                        coordinator.requestServiceFromAITapped(draft: draft, profileId: patientId)
                    },
                    onDismiss: {
                        coordinator.pop()
                    }
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
