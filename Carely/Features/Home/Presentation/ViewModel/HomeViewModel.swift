//
//  HomeViewModel.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import Combine
 
/// Number of category tiles shown in the Home preview grid before the
/// "More Services" tile that pushes to the full Service Categories screen.
private let homePreviewCategoryCount = 5
 
@MainActor
final class HomeViewModel: ObservableObject {
    
    @Published var greetingName: String = ""
    @Published var previewCategories: [ServiceCategory] = []
    @Published var upcomingBookings: [UpcomingBooking] = []
    @Published var profileImageUrl: String? = nil
    @Published var isLoading: Bool = false
    
    /// Drives the full-page `ErrorStateView` when the *initial* dashboard
    /// load fails (i.e. we don't have any data on screen yet).
    @Published var loadError: Error? = nil
    
    /// Drives the floating `.errorToast` for background refresh / retry
    /// failures that happen while we already have data on screen.
    @Published var errorMessage: String? = nil
    
    private let getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol
    private let getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol
    private let sessionManager: SessionManager
    private let serviceTypesStore: ServiceTypesStore
    private var cancellables = Set<AnyCancellable>()
    
    private var onServiceTabbed: (String) -> Void
    private var onSeeAllHistory: () -> Void

    init(
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol,
        sessionManager: SessionManager,
        serviceTypesStore: ServiceTypesStore,
        onServiceTabbed: @escaping (String) -> Void,
        onSeeAllHistory: @escaping () -> Void = {}
    ) {
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.getUpcomingBookingsUseCase = getUpcomingBookingsUseCase
        self.sessionManager = sessionManager
        self.serviceTypesStore = serviceTypesStore
        self.onServiceTabbed = onServiceTabbed
        self.onSeeAllHistory = onSeeAllHistory
        
        // Populate immediately from shared in-memory store if available
        if serviceTypesStore.hasCategories {
            self.previewCategories = Array(serviceTypesStore.serviceCategories.prefix(homePreviewCategoryCount))
        }
        
        setupUserObservation()
        setupStoreObservation()
    }
    
    private func setupUserObservation() {
        sessionManager.$currentUser
            .receive(on: RunLoop.main)
            .sink { [weak self] user in
                self?.greetingName = user?.firstName ?? "User"
                self?.profileImageUrl = user?.profileImageUrl
            }
            .store(in: &cancellables)
    }
    
    private func setupStoreObservation() {
        serviceTypesStore.$serviceCategories
            .receive(on: RunLoop.main)
            .sink { [weak self] categories in
                guard let self, !categories.isEmpty else { return }
                self.previewCategories = Array(categories.prefix(homePreviewCategoryCount))
            }
            .store(in: &cancellables)
    }
    
    func onAppear() {
        guard previewCategories.isEmpty || upcomingBookings.isEmpty else { return }
        loadDashboard()
    }
    
    /// Retries the initial load from the full-page `ErrorStateView`.
    func retryInitialLoad() {
        loadDashboard()
    }
    
    func loadDashboard() {
        let isInitialLoad = previewCategories.isEmpty

        if isInitialLoad {
            isLoading = true
        }
        loadError = nil
        errorMessage = nil
        
        Task {
            do {
                if serviceTypesStore.hasCategories {
                    // Service categories already exist in memory -> only fetch bookings
                    let bookings = try await self.getUpcomingBookingsUseCase.execute()
                    self.upcomingBookings = bookings
                } else {
                    // Fetch categories and bookings in parallel
                    async let categoriesTask = self.getServiceCategoriesUseCase.execute()
                    async let bookingsTask = self.getUpcomingBookingsUseCase.execute()
                    
                    let (fetchedCategories, fetchedBookings) = try await (categoriesTask, bookingsTask)
                    
                    self.serviceTypesStore.setCategories(fetchedCategories)
                    self.previewCategories = Array(fetchedCategories.prefix(homePreviewCategoryCount))
                    self.upcomingBookings = fetchedBookings
                }
                self.isLoading = false
            } catch {
                self.isLoading = false
                
                // No data on screen yet -> full-page error state with retry.
                // Already have data (e.g. pull-to-refresh) -> just toast it.
                if isInitialLoad {
                    self.loadError = error
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    func categoryTapped(_ category: ServiceCategory) {
        onServiceTabbed(category.id)
    }
    
    func viewAllServicesTapped() {
        // navigate to all services
    }
    
    func seeAllHistoryTapped() {
        onSeeAllHistory()
    }
}
