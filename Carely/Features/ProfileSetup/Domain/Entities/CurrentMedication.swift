//
//  CurrentMedication.swift
//  Carely
//

import Foundation

struct PatientMedication: Identifiable, Equatable, Hashable {
    var id: String            // medicationId (UUID string) or temp client ID for unsaved drafts
    let recordId: String?     // profile-medication relationship record ID (id)
    var name: String          // medicationName

    init(id: String = "", recordId: String? = nil, name: String = "") {
        self.id = id
        self.recordId = recordId
        self.name = name
    }
}

struct CurrentMedication: Equatable {
    var hasNoCurrentMedications: Bool = false
    var medications: [PatientMedication] = []
    var prescriptionPhotoData: Data? = nil
}
