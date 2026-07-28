//
//  OnboardingViewModel.swift
//  Carely
//

import Foundation

enum OnboardingAction {
    case onSkipClicked
    case onNextClicked(totalPages: Int)
    case onCardSwiped(newIndex: Int, totalPages: Int)
}

struct OnboardingState: Equatable {
    var currentPageIndex: Int = 0
}

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published private(set) var state = OnboardingState()
    
    var onNavigate: (() -> Void)
    
    init(onNavigate:@escaping ()->Void) {
        self.onNavigate = onNavigate
    }
    
    func onAction(_ action: OnboardingAction) {
        switch action {
        case .onSkipClicked:
            onNavigate()
            
        case .onNextClicked(let totalPages):
            if state.currentPageIndex < totalPages - 1 {
                state.currentPageIndex += 1
            } else {
                onNavigate()
            }
            
        case .onCardSwiped(let newIndex, let totalPages):
            if newIndex >= 0 && newIndex < totalPages {
                state.currentPageIndex = newIndex
            } else if newIndex >= totalPages {
                onNavigate()
            }
        }
    }
}
