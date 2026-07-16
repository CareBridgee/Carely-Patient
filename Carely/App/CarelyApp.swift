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
    
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.phase == .auth {
                AuthCoordinator { appState.signIn() }
            } else {
                ContentView()
            }
        }
    }
}
