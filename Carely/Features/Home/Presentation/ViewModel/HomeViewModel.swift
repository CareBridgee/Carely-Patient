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
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
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
    )  {
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
 
    func loadDashboard() {
        // Only trigger loading indicator if we don't have categories in memory yet
        if previewCategories.isEmpty {
            isLoading = true
        }
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
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
 
    // MARK: - Navigation
 
    func categoryTapped(_ category: ServiceCategory) {
        onServiceTabbed(category.id)
    }
 
    func viewAllServicesTapped() {
        //
    }

    func seeAllHistoryTapped() {
        onSeeAllHistory()
    }
}
