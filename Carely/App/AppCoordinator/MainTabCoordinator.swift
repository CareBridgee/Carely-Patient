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
    @Published var currentNotification: NotificationData?
    @Published var selectedTab: AppTab = .home

    private var previousTab: AppTab = .home
    let homeCoordinator: HomeCoordinator
    let servicesCoordinator: ServicesCoordinator
    let aiAssistantCoordinator: AIAssistantCoordinator
    let profileCoordinator: ProfileCoordinator
    private var notificationsHubService: NotificationsHubServiceProtocol
    private let appState: AppState

    init(appState: AppState, container: DIContainer) {
        let home = HomeCoordinator()
        let services = ServicesCoordinator()
        let aiAssistant = AIAssistantCoordinator()
        let profile = ProfileCoordinator()

        self.homeCoordinator = home
        self.servicesCoordinator = services
        self.aiAssistantCoordinator = aiAssistant
        self.profileCoordinator = profile
        self.appState = appState
        self.notificationsHubService = container.getNotificationsHubService()
            
            wireCrossTabNavigation()
            setupNotifications()
    }

    // MARK: - Cross-Tab Wiring

    private func wireCrossTabNavigation() {
        
        homeCoordinator.onViewAllServices = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
        }

        homeCoordinator.onOpenService = { [weak self] serviceId in
            self?.openService(id: serviceId)
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

        aiAssistantCoordinator.onAddFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.servicesCoordinator.push(to: .addFamilyMember)
        }

        profileCoordinator.onLoggedOut = { [weak self] in
            self?.appState.startAuthFlow()
        }
    }

    // MARK: - Cross-Tab Navigation

    func openService(id: String) {
        selectedTab = .services
        servicesCoordinator.openServiceFromHome(id: id)
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
    // Add these methods
    private func setupNotifications() {
        notificationsHubService.onNotificationReceived = { [weak self] response in
            guard let self = self else { return }
            
            let data = NotificationData(
                title: response.title,
                message: response.message,
                type: response.type
            )
            self.currentNotification = data
        }
        notificationsHubService.connectAndSubscribe()
    }

    func handleNotificationTap() {
        guard let notif = currentNotification else { return }
        if notif.type == "MESSAGE" {
            self.selectedTab = .services 
        }
    }
}
