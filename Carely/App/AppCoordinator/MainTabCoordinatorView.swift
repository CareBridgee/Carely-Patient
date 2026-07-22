//
//  MainTabCoordinatorView.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import SwiftUI

// MARK: - MainTabCoordinatorView

struct MainTabCoordinatorView: View {

    let container: DIContainer
    let appState: AppState
    @StateObject private var coordinator = MainTabCoordinator()

    var body: some View {
        tabContent
            .safeAreaInset(edge: .bottom, spacing: 0) {
                FloatingTabBar(selectedTab: Binding(
                    get: { coordinator.selectedTab },
                    set: { coordinator.select($0) }
                ))
            }
    }

    // MARK: - Tab Content

    private var tabContent: some View {
        ZStack {
            HomeCoordinatorView(container: container, coordinator: coordinator.homeCoordinator)
                .opacity(coordinator.selectedTab == .home ? 1 : 0)
                .allowsHitTesting(coordinator.selectedTab == .home)

//            ServicesCoordinatorView(container: container, coordinator: coordinator.servicesCoordinator)
//                .opacity(coordinator.selectedTab == .services ? 1 : 0)
//                .allowsHitTesting(coordinator.selectedTab == .services)
//
//            AICoordinatorView(container: container, coordinator: coordinator.aiCoordinator)
//                .opacity(coordinator.selectedTab == .ai ? 1 : 0)
//                .allowsHitTesting(coordinator.selectedTab == .ai)
//
//            ProfileCoordinatorView(container: container, coordinator: coordinator.profileCoordinator, appState: appState)
//                .opacity(coordinator.selectedTab == .profile ? 1 : 0)
//                .allowsHitTesting(coordinator.selectedTab == .profile)
        }
        .animation(.easeInOut(duration: 0.15), value: coordinator.selectedTab)
    }
}
