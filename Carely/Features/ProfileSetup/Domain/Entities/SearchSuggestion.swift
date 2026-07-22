//
//  SearchSuggestion.swift
//  Carely
//

import Foundation

struct SearchSuggestion: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subtitle: String
}
