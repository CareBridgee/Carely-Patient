//
//  CarelyApp.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import SwiftUI

@main
struct CarelyApp: App {
    
    let diContainer :DIContainer
    @MainActor
    init() {
        self.diContainer = DIContainer()
    }
    var body: some Scene {
        // state
        WindowGroup {
            // switch based on state
            //case AuthCoordinator OnFinish)(change state)
           // ContentView()
            AuthCoordinator(container: diContainer){}
        }
    }
}
