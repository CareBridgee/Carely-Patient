//
//  PhoneNumberViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 17/07/2026.
//

import SwiftUI

@MainActor
final class PhoneNumberViewModel: ObservableObject {
    private let router: AuthRouter
    @Published var phoneNumber: String = ""
 
    init(router: AuthRouter) {
        self.router = router
    }
    
    func nextButtonPressed(){
        router.push(to: .OTPVerification(phoneNumber: phoneNumber))
    }
}
