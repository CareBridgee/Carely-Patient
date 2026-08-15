//
//  ServiceTypesStore.swift
//  Carely
//
//  Created by Mohamed Ayman on 15/08/2026.
//

import Foundation
import Combine

@MainActor
final class ServiceTypesStore: ObservableObject {
    @Published private(set) var serviceCategories: [ServiceCategory] = []

    init() {}

    var hasCategories: Bool {
        !serviceCategories.isEmpty
    }

    func setCategories(_ categories: [ServiceCategory]) {
        self.serviceCategories = categories
    }

    func clear() {
        self.serviceCategories = []
    }
}
