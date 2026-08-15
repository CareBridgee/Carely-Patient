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
    @StateObject private var coordinator: MainTabCoordinator

    init(container: DIContainer, appState: AppState) {
        self.container = container
        self.appState = appState
        _coordinator = StateObject(wrappedValue: MainTabCoordinator(appState: appState, container: container))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.backGround
                .ignoresSafeArea()

            tabContent
                .padding(.bottom, coordinator.isTabBarVisible ? Spacing.s56 : Spacing.s0)
            
            if coordinator.isTabBarVisible {
                FloatingTabBar(
                    selectedTab: Binding(
                        get: { coordinator.selectedTab },
                        set: { coordinator.select($0) }
                    )
                )
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: coordinator.isTabBarVisible)
        .background(Color.backGround.ignoresSafeArea())
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .notificationBanner(data: $coordinator.currentNotification) {
                coordinator.handleNotificationTap()
            }
        .fullScreenCover(isPresented: $coordinator.isHistoryPresented) {
            HistoryCoordinatorView(container: container, coordinator: coordinator.historyCoordinator)
        }
    }
    // MARK: - Tab Content

    private var tabContent: some View {
        ZStack {
            HomeCoordinatorView(container: container, coordinator: coordinator.homeCoordinator)
                .opacity(coordinator.selectedTab == .home ? 1 : 0)
                .allowsHitTesting(coordinator.selectedTab == .home)

            ServicesCoordinatorView(container: container, coordinator: coordinator.servicesCoordinator)
                .opacity(coordinator.selectedTab == .services ? 1 : 0)
                .allowsHitTesting(coordinator.selectedTab == .services)
            
            AIAssistantCoordinatorView(container: container, coordinator: coordinator.aiAssistantCoordinator)
                .opacity(coordinator.selectedTab == .ai ? 1 : 0)
                .allowsHitTesting(coordinator.selectedTab == .ai)

            ProfileCoordinatorView(container: container, coordinator: coordinator.profileCoordinator)
                .opacity(coordinator.selectedTab == .profile ? 1 : 0)
                .allowsHitTesting(coordinator.selectedTab == .profile)
        }
        .animation(.easeInOut(duration: 0.15), value: coordinator.selectedTab)
    }
}
