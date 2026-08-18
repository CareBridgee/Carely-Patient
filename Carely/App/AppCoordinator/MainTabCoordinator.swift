//
//  MainTabCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation
import Combine
 
// MARK: - MainTabCoordinator
 
@MainActor
final class MainTabCoordinator: ObservableObject {
    @Published var currentNotification: NotificationData?
    @Published var selectedTab: AppTab = .home
 
    private var previousTab: AppTab = .home
    let homeCoordinator: HomeCoordinator
    let servicesCoordinator: ServicesCoordinator
    let historyCoordinator: HistoryCoordinator
    let aiAssistantCoordinator: AIAssistantCoordinator
    let profileCoordinator: ProfileCoordinator
    private var notificationsHubService: NotificationsHubServiceProtocol
    private let appState: AppState
    private var cancellables = Set<AnyCancellable>()

    /// Tab bar is visible ONLY on the root screen of each tab.
    var isTabBarVisible: Bool {
        switch selectedTab {
        case .home:
            return homeCoordinator.path.isEmpty
        case .services:
            return servicesCoordinator.path.isEmpty
        case .history:
            return historyCoordinator.path.isEmpty
        case .profile:
            return profileCoordinator.path.isEmpty
        }
    }


     init(appState: AppState, container: DIContainer) {
        let home = HomeCoordinator()
        let services = ServicesCoordinator()
        let history = HistoryCoordinator()
        let aiAssistant = AIAssistantCoordinator()
        let profile = ProfileCoordinator()
 
        self.homeCoordinator = home
        self.servicesCoordinator = services
        self.historyCoordinator = history
        self.aiAssistantCoordinator = aiAssistant
        self.profileCoordinator = profile
        self.appState = appState
        self.notificationsHubService = container.getNotificationsHubService()
            
            wireCrossTabNavigation()
            setupNotifications()
            observeChildCoordinators()
    }

    private func observeChildCoordinators() {
        homeCoordinator.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        servicesCoordinator.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        historyCoordinator.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)

        profileCoordinator.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
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
        homeCoordinator.onOpenActiveVisit = { [weak self] offer in
            guard let self = self else { return }
            self.selectedTab = .services
            self.servicesCoordinator.openActiveVisit(offer: offer)
        }
 
        homeCoordinator.onOpenHistory = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .history
        }

        homeCoordinator.onRequestServiceFromAI = { [weak self] draft, profileId in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.servicesCoordinator.openRequestFromAIAssistant(draft: draft, profileId: profileId)
        }
 
        historyCoordinator.onExploreServices = { [weak self] in
            guard let self = self else { return }
            self.historyCoordinator.popToRoot()
            self.previousTab = self.selectedTab
            self.selectedTab = .services
        }
        
        bindCrossTabBack(to: servicesCoordinator)
        bindCrossTabBack(to: historyCoordinator)
        
        profileCoordinator.onLoggedOut = { [weak self] in
            self?.appState.startAuthFlow()
        }
 
        profileCoordinator.onAddFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.servicesCoordinator.push(to: .addFamilyMember)
            // When the flow finishes, switch back to Profile. The list updates reactively.
            self.servicesCoordinator.onAddFamilyMemberFromProfileFinished = { [weak self] in
                guard let self = self else { return }
                self.selectedTab = self.previousTab
            }
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
            
            // Suppress banner notifications if user is currently inside the chat screen
            if self.servicesCoordinator.isInsideChat {
                print("[MainTabCoordinator] User is currently inside Chat screen. Suppressing top banner notification.")
                return
            }
            
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
