//
//  CarelyApp.swift
//  Carely
//
//  Created by Mona Zarea on 15/07/2026.
//

import SwiftUI

@main
struct CarelyApp: App {
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
