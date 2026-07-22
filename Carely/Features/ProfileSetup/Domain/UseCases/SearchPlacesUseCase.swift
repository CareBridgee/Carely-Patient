//
//  SearchPlacesUseCase.swift
//  Carely
//

import Foundation

final class SearchPlacesUseCase {

    private let repository: HomeAddressRepositoryProtocol

    init(repository: HomeAddressRepositoryProtocol) {
        self.repository = repository
    }

    func observeSuggestions(handler: @escaping ([SearchSuggestion]) -> Void) {
        repository.setSearchSuggestionsHandler(handler)
    }

    func updateQuery(_ query: String) {
        repository.updateSearchQuery(query)
    }
}
