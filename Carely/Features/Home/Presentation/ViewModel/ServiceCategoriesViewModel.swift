//
//  ServiceCategoriesViewModel.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import Foundation
import Combine
 
@MainActor
final class ServiceCategoriesViewModel: ObservableObject {
 
    @Published var searchQuery: String = "" {
        didSet { scheduleSearch() }
    }
    @Published private(set) var categories: [ServiceCategory] = []
 
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
    private let getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol
    private let searchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol
 
    private var searchTask: Task<Void, Never>?
 
    init(
        getServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol,
        searchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol,
    ) {
        self.getServiceCategoriesUseCase = getServiceCategoriesUseCase
        self.searchServiceCategoriesUseCase = searchServiceCategoriesUseCase
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
        //
    }
 
    func backTapped() {
        //
    }
}
 
