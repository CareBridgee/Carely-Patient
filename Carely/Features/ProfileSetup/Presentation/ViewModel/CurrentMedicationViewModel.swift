//
//  CurrentMedicationViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 19/07/2026.
//

import Foundation
 
@MainActor
final class CurrentMedicationViewModel: ObservableObject {
  
    @Published var hasNoCurrentMedications: Bool {
        didSet { handleNoCurrentMedicationsToggleChanged() }
    }
    @Published var medications: [MedicationItem]
    @Published var prescriptionPhotoData: Data?
 
 
    private let coordinator: ProfileSetupCoordinator
 
 
    init(coordinator: ProfileSetupCoordinator) {
        self.coordinator = coordinator
 
        let existing = coordinator.data.currentMedication
        self.hasNoCurrentMedications = existing.hasNoCurrentMedications
        self.medications = existing.medications.isEmpty ? [MedicationItem()] : existing.medications
        self.prescriptionPhotoData = existing.prescriptionPhotoData
    }
 
 
    func addMedicationTapped() {
        medications.append(MedicationItem())
    }
 
    func removeMedication(_ entry: MedicationItem) {
        guard medications.count > 1 else { return }
        medications.removeAll { $0.id == entry.id }
    }
 
    func prescriptionPhotoPicked(_ data: Data?) {
        prescriptionPhotoData = data
    }
 
    func backTapped() {
        persist()
        coordinator.previous()
    }
 
    func continueTapped() {
        persist()
        coordinator.next()
    }
 
 
    private func handleNoCurrentMedicationsToggleChanged() {
        guard hasNoCurrentMedications else { return }
        medications = [MedicationItem()]
        prescriptionPhotoData = nil
    }
 
    private func persist() {
        let currentMedication = CurrentMedication(
            hasNoCurrentMedications: hasNoCurrentMedications,
            medications: medications,
            prescriptionPhotoData: prescriptionPhotoData
        )
        coordinator.save(currentMedication: currentMedication)
    }
}
