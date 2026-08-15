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
    private let serviceTypesStore: ServiceTypesStore
    private var cancellables = Set<AnyCancellable>()
 
    private var searchTask: Task<Void, Never>?
    private var coordinator: ServicesCoordinator
    
    init(
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        searchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol,
        sessionManager: SessionManager,
        serviceTypesStore: ServiceTypesStore,
        coordinator: ServicesCoordinator
    ) {
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.searchServiceCategoriesUseCase = searchServiceCategoriesUseCase
        self.sessionManager = sessionManager
        self.serviceTypesStore = serviceTypesStore
        self.coordinator = coordinator
        
        // Populate immediately from shared in-memory store if available
        if serviceTypesStore.hasCategories {
            self.categories = serviceTypesStore.serviceCategories
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
                guard let self else { return }
                if self.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.categories = categories
                }
            }
            .store(in: &cancellables)
    }
 
    func onAppear() {
        guard categories.isEmpty else { return }
        loadCategories()
    }
 
    func loadCategories() {
        if serviceTypesStore.hasCategories {
            self.categories = serviceTypesStore.serviceCategories
            return
        }

        isLoading = true
        errorMessage = nil
 
        Task {
            do {
                let fetched = try await self.getServiceCategoriesUseCase.execute()
                self.serviceTypesStore.setCategories(fetched)
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
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if query.isEmpty {
            self.categories = serviceTypesStore.serviceCategories
            return
        }
        searchTask = Task {
            do {
                let results = try await searchServiceCategoriesUseCase.execute(query: query)
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
