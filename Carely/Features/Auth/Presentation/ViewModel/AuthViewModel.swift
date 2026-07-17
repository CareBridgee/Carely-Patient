//
//  WelcomeViewModel.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import Foundation

final class WelcomeViewModel: ObservableObject {

    private let router: AuthRouter

    init(router: AuthRouter) {
        self.router = router
    }

    func continueWithPhone() {
        router.push(to: .PhoneNumber)
    }
}
