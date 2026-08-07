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
    
    init() {}
    
    func initializeApp() {
        Task {
            async let minimumDelay: () = Task.sleep(nanoseconds: 1_500_000_000)
            async let setupTask: () = performAppSetup()
            
            _ = try? await (minimumDelay, setupTask)
            
            onSplashFinished?()
        }
    }
    
    private func performAppSetup() async {
        
    }
}
