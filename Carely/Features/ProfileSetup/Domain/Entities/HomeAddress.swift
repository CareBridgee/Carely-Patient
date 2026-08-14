//
//  HomeAddress.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

// MARK: - HomeAddress

struct HomeAddress: Equatable, Codable {
    var country: String
    var city: String
    var area: String
    var streetName: String
    var building: String
    var apartment: String
    var latitude: Double?
    var longitude: Double?

    init(
        country: String = "",
        city: String = "",
        area: String = "",
        streetName: String = "",
        building: String = "",
        apartment: String = "",
        latitude: Double? = nil,
        longitude: Double? = nil
    ) {
        self.country = country
        self.city = city
        self.area = area
        self.streetName = streetName
        self.building = building
        self.apartment = apartment
        self.latitude = latitude
        self.longitude = longitude
    }

    var isEmpty: Bool {
        country.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        area.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        streetName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        building.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        apartment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
