//
//  MainTabCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation

// MARK: - MainTabCoordinator

@MainActor
final class MainTabCoordinator: ObservableObject {

    @Published var selectedTab: AppTab = .home

    let homeCoordinator: HomeCoordinator
    let servicesCoordinator: ServicesCoordinator
//    let aiCoordinator: AICoordinator
//    let profileCoordinator: ProfileCoordinator

    init() {
        let home = HomeCoordinator()
        let services = ServicesCoordinator()
//        let ai = AICoordinator()
//        let profile = ProfileCoordinator()

        self.homeCoordinator = home
        self.servicesCoordinator = services
//        self.aiCoordinator = ai
//        self.profileCoordinator = profile

        wireCrossTabNavigation()
    }

    // MARK: - Cross-Tab Wiring

    private func wireCrossTabNavigation() {
        homeCoordinator.onViewAllServices = { [weak self] in
            self?.selectedTab = .services
        }

        homeCoordinator.onOpenService = { [weak self] in
            self?.openService()
        }
//
//        homeCoordinator.onOpenActiveVisit = { [weak self] in
//            self?.openActiveVisit()
//        }

        homeCoordinator.onOpenAIAssistant = { [weak self] in
            self?.selectedTab = .ai
        }
        
        servicesCoordinator.onBackClicked = { [weak self] in
            self?.selectedTab = .home
            self?.servicesCoordinator.popToRoot()
        }
    }

    // MARK: - Cross-Tab Navigation

    func openService() { // will inject service here
        selectedTab = .services
        servicesCoordinator.openServiceFromHome()
    }

//    func openActiveVisit() { // will inject current visit here
//        selectedTab = .services
//        servicesCoordinator.open()
//    }

    func select(_ tab: AppTab) {
        selectedTab = tab
    }
}
