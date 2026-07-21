//
//  ExistingConditionsViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class ExistingConditionsViewModel: ObservableObject {
    @Published var existingConditions: ExistingConditions
    
    init(existingData: ExistingConditions) {
        self.existingConditions = existingData
        
    }
    let availableConditions: [(title: String, icon: String)] = [
        ("Diabetes", "diabetes-icon"),
        ("Hypertension", "hypertension-icon"),
        ("Heart Disease", "heart-disease-icon"),
        ("Asthma", "asthma-icon"),
        ("COPD", "COPD-icon"),
        ("Epilepsy", "epilepsy-icon"),
        ("Liver Disease", "liver-disease-icon")
    ]
    func toggleCondition(_ condition: String) {
        if existingConditions.selectedConditions.contains(condition) {
            existingConditions.selectedConditions.remove(condition)
        } else {
            existingConditions.selectedConditions.insert(condition)
        }
    }
}
