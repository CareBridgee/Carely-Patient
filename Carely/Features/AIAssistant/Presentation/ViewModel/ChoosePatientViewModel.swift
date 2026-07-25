//
//  ChoosePatientViewModel.swift
//  Carely
//
//  Created by AI Assistant
//

import Foundation
import Combine

@MainActor
class ChoosePatientViewModel: ObservableObject {
    @Published var patients: [AIPatient] = []
    @Published var selectedPatientId: String? = nil
    @Published var isLoading = false
    
    private let getAIPatientsUseCase: GetAIPatientsUseCaseProtocol
    let onShowPatientDetails: ((String) -> Void)?
    let onContinueWithAssessmentClosure: (String) -> Void
    
    init(
        getAIPatientsUseCase: GetAIPatientsUseCaseProtocol,
        onShowPatientDetails: ((String) -> Void)?,
        onContinueWithAssessment: @escaping (String) -> Void
    ) {
        self.getAIPatientsUseCase = getAIPatientsUseCase
        self.onShowPatientDetails = onShowPatientDetails
        self.onContinueWithAssessmentClosure = onContinueWithAssessment
    }
    
    func onAppear() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetchedPatients = try await getAIPatientsUseCase.execute()
            self.patients = fetchedPatients
            if self.selectedPatientId == nil, let first = fetchedPatients.first {
                self.selectedPatientId = first.id
            }
        } catch {
            print("Error fetching AI patients: \(error)")
        }
    }
    
    func selectPatient(_ patient: AIPatient) {
        selectedPatientId = patient.id
    }
    
    func continueWithAssessment() {
        guard let selectedId = selectedPatientId else { return }
        print("Continue with Assessment for patient: \(selectedId)")
        onContinueWithAssessmentClosure(selectedId)
    }
}
