//
//  CurrentMedication.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

struct MedicationItem: Identifiable, Equatable {
    let id: UUID
    var name: String
 
    init(id: UUID = UUID(), name: String = "") {
        self.id = id
        self.name = name
    }
}
 
struct CurrentMedication {
    var hasNoCurrentMedications: Bool = false
    var medications: [MedicationItem] = [MedicationItem()]
    var prescriptionPhotoData: Data? = nil
}
