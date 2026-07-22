//
//  AllergiesViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation

@MainActor
final class AllergiesViewModel: ObservableObject {
 
 
    @Published var hasNoKnownAllergies: Bool {
        didSet { handleNoKnownAllergiesToggleChanged() }
    }
    @Published var selectedDrugAllergies: Set<String>
    @Published var selectedFoodAllergies: Set<String>
    @Published var otherAllergiesText: String
 
 
    let drugAllergyOptions = [
        "Penicillin", "Sulfa Drugs", "Aspirin",
        "Ibuprofen", "Lidocaine", "Codeine", "Latex"
    ]
 
    let foodAllergyOptions = [
        "Peanuts", "Shellfish", "Dairy",
        "Eggs", "Soy", "Tree Nuts", "Wheat/Gluten"
    ]
 
 
    private let coordinator: ProfileSetupCoordinator
 
 
    init(coordinator: ProfileSetupCoordinator) {
        self.coordinator = coordinator
 
        let existing = coordinator.data.allergies
        self.hasNoKnownAllergies = existing.hasNoKnownAllergies
        self.selectedDrugAllergies = existing.drugAllergies
        self.selectedFoodAllergies = existing.foodAllergies
        self.otherAllergiesText = existing.otherAllergiesNote
    }
 
 
    func toggleDrugAllergy(_ value: String) {
        toggle(value, in: &selectedDrugAllergies)
    }
 
    func toggleFoodAllergy(_ value: String) {
        toggle(value, in: &selectedFoodAllergies)
    }
 
    func backTapped() {
        persist()
        coordinator.previous()
    }
 
    func continueTapped() {
        persist()
        coordinator.next()
    }
 
 
    private func handleNoKnownAllergiesToggleChanged() {
        guard hasNoKnownAllergies else { return }
        selectedDrugAllergies.removeAll()
        selectedFoodAllergies.removeAll()
        otherAllergiesText = ""
    }
 
    private func toggle(_ value: String, in set: inout Set<String>) {
        if set.contains(value) {
            set.remove(value)
        } else {
            set.insert(value)
        }
    }
 
    private func persist() {
        let allergies = Allergies(
            hasNoKnownAllergies: hasNoKnownAllergies,
            drugAllergies: selectedDrugAllergies,
            foodAllergies: selectedFoodAllergies,
            otherAllergiesNote: otherAllergiesText
        )
        coordinator.save(allergies: allergies)
    }
}
