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
    let historyCoordinator: HistoryCoordinator
    let aiAssistantCoordinator: AIAssistantCoordinator
    let profileCoordinator: ProfileCoordinator
    private var notificationsHubService: NotificationsHubServiceProtocol
    private let appState: AppState

    /// Weakly held so MainTabCoordinator can refresh the list after adding a member from the Profile tab.
    weak var familyMembersViewModel: FamilyMembersViewModel?


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
 
        homeCoordinator.onOpenHistory = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .history
        }
 
        historyCoordinator.onExploreServices = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.historyCoordinator.popToRoot()
        }
        
        bindCrossTabBack(to: servicesCoordinator)
        bindCrossTabBack(to: aiAssistantCoordinator)
        bindCrossTabBack(to: historyCoordinator)
        
//        servicesCoordinator.onBackClicked = { [weak self] in
//            guard let self = self else { return }
//            self.selectedTab = self.previousTab
//            self.servicesCoordinator.popToRoot()
//        }
        
        aiAssistantCoordinator.onRequestNow = { [weak self] draft, profileId in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.servicesCoordinator.openRequestFromAIAssistant(draft: draft, profileId: profileId)
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

        profileCoordinator.onFamilyMembersViewModelCreated = { [weak self] vm in
            self?.familyMembersViewModel = vm
        }

        profileCoordinator.onAddFamilyMember = { [weak self] in
            guard let self = self else { return }
            self.previousTab = self.selectedTab
            self.selectedTab = .services
            self.servicesCoordinator.push(to: .addFamilyMember)
            // When the flow finishes, switch back to Profile and refresh the list
            self.servicesCoordinator.onAddFamilyMemberFromProfileFinished = { [weak self] in
                guard let self = self else { return }
                self.selectedTab = self.previousTab
                self.familyMembersViewModel?.refreshMembers()
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
 
