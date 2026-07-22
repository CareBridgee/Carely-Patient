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
 
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
    private let getGreetingNameUseCase: GetGreetingNameUseCaseProtocol
    private let getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol
    private let getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol
    
    private var onServiceTabbed: () -> Void
    init(
        getGreetingNameUseCase: GetGreetingNameUseCaseProtocol,
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        getUpcomingBookingsUseCase: GetUpcomingBookingsUseCaseProtocol,
        onServiceTabbed: @escaping () -> Void
    ) {
        self.getGreetingNameUseCase = getGreetingNameUseCase
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.getUpcomingBookingsUseCase = getUpcomingBookingsUseCase
        self.onServiceTabbed = onServiceTabbed
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
                async let name = getGreetingNameUseCase.execute()
                async let categories = getServiceCategoriesUseCase.execute()
                async let bookings = getUpcomingBookingsUseCase.execute()
 
                let (fetchedName, fetchedCategories, fetchedBookings) = try await (name, categories, bookings)
 
                self.greetingName = fetchedName
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
        onServiceTabbed()
    }
 
    func viewAllServicesTapped() {
        //
    }
}
 
