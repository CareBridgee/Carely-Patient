//
//  ProfileSetupData.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

struct ProfileSetupData {

    var basicHealthInfo = BasicHealthInfo(height: nil, weight: nil, bloodType: "")

    var existingConditions = ExistingConditions(selectedConditions:[], otherDiseases: "")

    var allergies = Allergies()

    var currentMedication = CurrentMedication()

    var medicalHistory = MedicalHistory()

    var mobility = Mobility()

    var emergencyContact = EmergencyContact()

    var homeAddress = HomeAddress()
}
