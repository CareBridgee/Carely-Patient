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
    private var cancellables = Set<AnyCancellable>()
    
    private var onServiceTabbed: (String) -> Void
    private var onSeeAllHistory: () -> Void
    init(
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol,
        sessionManager: SessionManager,
        onServiceTabbed: @escaping (String) -> Void,
        onSeeAllHistory: @escaping () -> Void = {}
    )  {
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.getUpcomingBookingsUseCase = getUpcomingBookingsUseCase
        self.sessionManager = sessionManager
        self.onServiceTabbed = onServiceTabbed
        self.onSeeAllHistory = onSeeAllHistory
        
        setupUserObservation()
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
 
    func onAppear() {
        guard previewCategories.isEmpty, greetingName.isEmpty else { return }
        loadDashboard()
    }
 
    func loadDashboard() {
        isLoading = true
        errorMessage = nil
 
        Task {
            do {
                try await Task.withMinimumDuration {
                    async let categories = self.getServiceCategoriesUseCase.execute()
                    async let bookings = self.getUpcomingBookingsUseCase.execute()
 
                    let (fetchedCategories, fetchedBookings) = try await (categories, bookings)
  
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
