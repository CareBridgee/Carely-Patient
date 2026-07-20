//
//  PersonalInfoViewModel.swift
//  Carely
//
//  Created by Mona Zarea on 16/07/2026.
//

import Foundation
import SwiftUI
import Combine


//enum ViewState<T> {
//    case idle
//    case loading
//    case success(T)
//    case failure(AppError)

//}

@MainActor
final class PersonalInfoViewModel: ObservableObject {
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date? = nil
    @Published var gender: Gender = .male
    
    @Published var firstNameError: String? = nil
    @Published var lastNameError: String? = nil
    @Published var dobError: String? = nil
    
    @Published var isLoading: Bool = false
    @Published var apiErrorMessage: String? = nil
    @Published var showError: Bool = false
    
   // @Published var state: ViewState<> = .idle

    private let savePersonalInfoUseCase: SavePersonalInfoUseCaseProtocol
    private let router: AuthRouter
    private var onOersonalDataSaved: () -> Void
    init(
        savePersonalInfoUseCase: SavePersonalInfoUseCaseProtocol,
        router: AuthRouter,
        onOersonalDataSaved: @escaping () -> Void
    ) {
        self.savePersonalInfoUseCase = savePersonalInfoUseCase
        self.router = router
        self.onOersonalDataSaved = onOersonalDataSaved
    }
    
    func continueTapped() {
        //guard validateInputs() else { return }
        
        isLoading = true
        apiErrorMessage = nil
        
        let basicInfo = BasicUserInfo(
            firstName: firstName.trimmingCharacters(in: .whitespaces),
            secondName: lastName.trimmingCharacters(in: .whitespaces),
            dateOfBirth: dateOfBirth ?? Date(),
            Gender: gender
        )
        
        Task {
            do {
                try await savePersonalInfoUseCase.execute(basicInfo: basicInfo)
                onOersonalDataSaved()
                isLoading = false
                
                
            } catch {
                isLoading = false
                self.apiErrorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
    
    private func validateInputs() -> Bool {
            var isValid = true
            
            firstNameError = nil
            lastNameError = nil
            dobError = nil
            apiErrorMessage = nil
            
            if firstName.trimmingCharacters(in: .whitespaces).isEmpty {
                firstNameError = "First name is required"
                isValid = false
            }
            
            if lastName.trimmingCharacters(in: .whitespaces).isEmpty {
                lastNameError = "Last name is required"
                isValid = false
            }
            
            let calendar = Calendar.current
            if let dob = dateOfBirth {
                let ageComponents = calendar.dateComponents([.year], from: dob, to: Date())
                if let age = ageComponents.year, age < 18 {
                    dobError = "You must be +18 to use CareConnect"
                    isValid = false
                }
            } else {
                dobError = "Date of birth is required"
                isValid = false
            }
            
            return isValid
        }
}
