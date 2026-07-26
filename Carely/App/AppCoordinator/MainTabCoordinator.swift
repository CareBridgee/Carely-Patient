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

    private var previousTab: AppTab = .home
    let homeCoordinator: HomeCoordinator
    let servicesCoordinator: ServicesCoordinator
    let aiAssistantCoordinator: AIAssistantCoordinator
    let profileCoordinator: ProfileCoordinator

    private let appState: AppState

    init(appState: AppState) {
        let home = HomeCoordinator()
        let services = ServicesCoordinator()
        let aiAssistant = AIAssistantCoordinator()
        let profile = ProfileCoordinator()

        self.homeCoordinator = home
        self.servicesCoordinator = services
        self.aiAssistantCoordinator = aiAssistant
        self.profileCoordinator = profile
        self.appState = appState

        wireCrossTabNavigation()
    }

    // MARK: - Cross-Tab Wiring

    private func wireCrossTabNavigation() {
        
        homeCoordinator.onViewAllServices = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
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
        
        bindCrossTabBack(to: servicesCoordinator)
        bindCrossTabBack(to: aiAssistantCoordinator)
        
//        servicesCoordinator.onBackClicked = { [weak self] in
//            guard let self = self else { return }
//            self.selectedTab = self.previousTab
//            self.servicesCoordinator.popToRoot()
//        }
        
        aiAssistantCoordinator.onRequestNow = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.servicesCoordinator.openRequestFromAIAssistant()
        }
        
        aiAssistantCoordinator.onViewAllServices = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
        }

        profileCoordinator.onLoggedOut = { [weak self] in
            self?.appState.startAuthFlow()
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
    
    private func bindCrossTabBack<Router: AppRouterProtocol>(to router: Router) {
        router.onBackClicked = { [weak self, weak router] in
            guard let self = self, let router = router else { return }
                
            self.selectedTab = self.previousTab
                
            router.popToRoot()
        }
    }
}
