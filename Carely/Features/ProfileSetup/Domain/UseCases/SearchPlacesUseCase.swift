//
//  SearchPlacesUseCase.swift
//  Carely
//

import Foundation

final class SearchPlacesUseCase {

    private let repository: ProfileSetupRepositoryProtocol

    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }

    func observeSuggestions(handler: @escaping ([SearchSuggestion]) -> Void) {
        repository.setSearchSuggestionsHandler(handler)
    }

    func updateQuery(_ query: String) {
        repository.updateSearchQuery(query)
    }
}
