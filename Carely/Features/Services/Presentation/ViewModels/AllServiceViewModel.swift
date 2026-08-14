//
//  AllServiceViewModel.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import Combine
 
@MainActor
final class AllServiceViewModel: ObservableObject {
 
    @Published var searchQuery: String = "" {
        didSet { scheduleSearch() }
    }
    @Published private(set) var categories: [ServiceCategory] = []
    @Published private(set) var greetingName: String = ""
 
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    @Published var profileImageUrl: String? = nil
    private let getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol
    private let searchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol
    private let sessionManager: SessionManager
    private var cancellables = Set<AnyCancellable>()
 
    private var searchTask: Task<Void, Never>?
    private var coordinator: ServicesCoordinator
    
    init(
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        searchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol,
        sessionManager: SessionManager,
        coordinator: ServicesCoordinator
    ) {
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.searchServiceCategoriesUseCase = searchServiceCategoriesUseCase
        self.sessionManager = sessionManager
        self.coordinator = coordinator
        
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
        guard categories.isEmpty else { return }
        loadCategories()
    }
 
    func loadCategories() {
        isLoading = true
        errorMessage = nil
 
        Task {
            do {
                let fetched = try await getServiceCategoriesUseCase.execute()
                self.categories = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
 
    private func scheduleSearch() {
        searchTask?.cancel()
        searchTask = Task {
            do {
                let results = try await searchServiceCategoriesUseCase.execute(query: searchQuery)
                guard !Task.isCancelled else { return }
                self.categories = results
            } catch {
                guard !Task.isCancelled else { return }
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
 
    // MARK: - Navigation
 
    func categoryTapped(_ category: ServiceCategory) {
        coordinator.push(to: .serviceDetails(id: category.id, source: .services))
    }
 
    func backTapped() {
        //
    }
}
