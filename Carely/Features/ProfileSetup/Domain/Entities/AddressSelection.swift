//
//  AddressSelection.swift
//  Carely
//

import Foundation
import CoreLocation

struct AddressSelection {
    let country: String
    let city: String
    let area: String
    let street: String
    var building: String = ""
    let coordinate: CLLocationCoordinate2D
}
