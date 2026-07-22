//
//  MapSearchService.swift
//  Carely
//

import Foundation
import MapKit
import Combine

protocol MapSearchServiceProtocol {
    func updateSearchQuery(_ query: String)
    func searchSuggestions() -> AnyPublisher<[SearchSuggestion], Never>
    func resolveLocation(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D
}

final class MapSearchService: NSObject, MapSearchServiceProtocol {
    
    private let completer: MKLocalSearchCompleter
    private let querySubject = PassthroughSubject<String, Never>()
    private let suggestionsSubject = CurrentValueSubject<[SearchSuggestion], Never>([])
    private var cancellables = Set<AnyCancellable>()
    
    private var completionsMap: [SearchSuggestion: MKLocalSearchCompletion] = [:]
    
    override init() {
        self.completer = MKLocalSearchCompleter()
        super.init()
        
        self.completer.delegate = self
        self.completer.resultTypes = [.address, .pointOfInterest, .query]
        
        querySubject
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.suggestionsSubject.send([])
                    self.completionsMap.removeAll()
                } else {
                    self.completer.queryFragment = query
                }
            }
            .store(in: &cancellables)
    }
    
    func updateSearchQuery(_ query: String) {
        querySubject.send(query)
    }
    
    func searchSuggestions() -> AnyPublisher<[SearchSuggestion], Never> {
        suggestionsSubject.eraseToAnyPublisher()
    }
    
    func resolveLocation(for suggestion: SearchSuggestion) async throws -> CLLocationCoordinate2D {
        guard let completion = completionsMap[suggestion] else {
            throw NSError(domain: "MapSearchService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Suggestion not found."])
        }
        
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        
        let response = try await search.start()
        guard let coordinate = response.mapItems.first?.placemark.coordinate else {
            throw NSError(domain: "MapSearchService", code: 2, userInfo: [NSLocalizedDescriptionKey: "Location not found."])
        }
        
        return coordinate
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension MapSearchService: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let results = Array(completer.results.prefix(5))
        var newMap: [SearchSuggestion: MKLocalSearchCompletion] = [:]
        
        let suggestions = results.map { completion -> SearchSuggestion in
            let suggestion = SearchSuggestion(title: completion.title, subtitle: completion.subtitle)
            newMap[suggestion] = completion
            return suggestion
        }
        
        self.completionsMap = newMap
        self.suggestionsSubject.send(suggestions)
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        self.completionsMap.removeAll()
        self.suggestionsSubject.send([])
    }
}
