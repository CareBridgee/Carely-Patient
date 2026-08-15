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
 
    @Published var hasActiveVisit: Bool = false
    @Published var activeVisitRequest: ConfirmedOffer? = nil
    @Published var greetingName: String = ""
    @Published var previewCategories: [ServiceCategory] = []
    @Published var upcomingBookings: [UpcomingBooking] = []
    @Published var profileImageUrl: String? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
    private let getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol
    private let getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol
    private let getActiveVisitUseCase: GetActiveVisitUseCaseProtocol?
    private let activeVisitStore: ActiveVisitStore?
    private let sessionManager: SessionManager
    private var cancellables = Set<AnyCancellable>()
    
    private var onServiceTabbed: (String) -> Void
    private var onSeeAllHistory: () -> Void
    private var onOpenActiveVisit: ((ConfirmedOffer) -> Void)?

    init(
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol,
        getActiveVisitUseCase: GetActiveVisitUseCaseProtocol? = nil,
        activeVisitStore: ActiveVisitStore? = nil,
        sessionManager: SessionManager,
        onServiceTabbed: @escaping (String) -> Void,
        onSeeAllHistory: @escaping () -> Void = {},
        onOpenActiveVisit: ((ConfirmedOffer) -> Void)? = nil
    )  {
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.getUpcomingBookingsUseCase = getUpcomingBookingsUseCase
        self.getActiveVisitUseCase = getActiveVisitUseCase
        self.activeVisitStore = activeVisitStore
        self.sessionManager = sessionManager
        self.onServiceTabbed = onServiceTabbed
        self.onSeeAllHistory = onSeeAllHistory
        self.onOpenActiveVisit = onOpenActiveVisit
        
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

        activeVisitStore?.$activeVisit
            .receive(on: RunLoop.main)
            .sink { [weak self] offer in
                self?.activeVisitRequest = offer
                self?.hasActiveVisit = (offer != nil)
            }
            .store(in: &cancellables)
    }
 
    func onAppear() {
        checkActiveVisit()
        if previewCategories.isEmpty {
            loadDashboard()
        }
    }

    func checkActiveVisit() {
        guard let useCase = getActiveVisitUseCase else { return }
        Task {
            do {
                if let offer = try await useCase.execute() {
                    self.activeVisitStore?.setActiveVisit(offer)
                } else {
                    self.activeVisitStore?.clearActiveVisit()
                }
            } catch {
                self.activeVisitStore?.clearActiveVisit()
            }
        }
    }
 
    func activeVisitBannerTapped() {
        if let offer = activeVisitRequest {
            onOpenActiveVisit?(offer)
        }
    }

    func loadDashboard() {
            isLoading = true
            errorMessage = nil
     
            Task {
                do {
                    async let categories = getServiceCategoriesUseCase.execute()
                    async let bookings = getUpcomingBookingsUseCase.execute()
     
                    let (fetchedCategories, fetchedBookings) = try await (categories, bookings)
      
                    self.previewCategories = Array(fetchedCategories.prefix(homePreviewCategoryCount))
                    self.upcomingBookings = fetchedBookings
                    
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
