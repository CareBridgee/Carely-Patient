//
//  SplashViewModel.swift
//  Carely
//

import Foundation

enum SplashEffect {
    case splashFinished
}

struct SplashState: Equatable {
    // Add any state properties if needed in the future
}

@MainActor
final class SplashViewModel: ObservableObject {
    @Published private(set) var state = SplashState()
    
    var onSplashFinished: (() -> Void)?
    
    private let sessionManager: SessionManager
    private let restoreSessionUseCase: RestoreSessionUseCaseProtocol
    
    init(sessionManager: SessionManager, restoreSessionUseCase: RestoreSessionUseCaseProtocol) {
        self.sessionManager = sessionManager
        self.restoreSessionUseCase = restoreSessionUseCase
    }
    
    func initializeApp() {
        Task {
            async let minimumDelay: () = Task.sleep(nanoseconds: 1_500_000_000)
            async let setupTask: () = performAppSetup()
            
            _ = try? await (minimumDelay, setupTask)
            
            onSplashFinished?()
        }
    }
    
    private func performAppSetup() async {
        if sessionManager.state == .restoring {
            do {
                try await restoreSessionUseCase.execute()
            } catch {
                // If it fails (e.g. 401 Unauthorized), we set it to loggedOut
                // For other errors, we might want to show a retry, but for now we just log out to be safe.
                sessionManager.setLoggedOut()
            }
        }
    }
}
