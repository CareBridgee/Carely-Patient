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
                .padding(.bottom, coordinator.isTabBarVisible ? 50 : Spacing.s0)
            
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
        .onChange(of: coordinator.selectedTab) { _ in
                   Task {
                       await RefundRecoveryService.shared?.processPendingRefunds()
                   }
               }
    }
    // MARK: - Tab Content

    private var tabContent: some View {
        Group {
            switch coordinator.selectedTab {
            case .home:
                HomeCoordinatorView(container: container, coordinator: coordinator.homeCoordinator)
            case .services:
                ServicesCoordinatorView(container: container, coordinator: coordinator.servicesCoordinator)
            case .ai:
                AIAssistantCoordinatorView(container: container, coordinator: coordinator.aiAssistantCoordinator)
            case .profile:
                ProfileCoordinatorView(container: container, coordinator: coordinator.profileCoordinator)
            }
        }
    }
}
