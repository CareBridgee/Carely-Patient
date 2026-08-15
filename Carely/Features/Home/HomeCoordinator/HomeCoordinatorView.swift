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
            onSeeAllHistory: coordinator.seeAllHistoryTapped
        ))
    }

    var body: some View {
        NavigationStack {
            HomeView(viewModel: container.makeHomeViewModel(
                onServiceTabbed: coordinator.serviceTapped,
                onSeeAllHistory: coordinator.seeAllHistoryTapped,
                onOpenActiveVisit: coordinator.activeVisitTapped
            ))
        }
    }
}
