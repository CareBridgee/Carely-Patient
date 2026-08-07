//
//  AIAssistantCoordinatorView.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import SwiftUI

struct AIAssistantCoordinatorView: View {
    let container : DIContainer
    @ObservedObject var coordinator:AIAssistantCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path){
            AIChatView(viewModel: container.makeAIChatViewModel())
            .navigationDestination(for: AIAssistantRoute.self){ route in
                destination(for: route)
            }
        }
    }
    @ViewBuilder
    private func destination(for route: AIAssistantRoute)-> some View{
        switch route{
            
        case .aiAssistantChat(let selectedId):
            AIChatView(viewModel: container.makeAIChatViewModel())
        }
    }
}
//
//#Preview {
//    AIAssistantCoordinatorView(container: <#DIContainer#>, coordinator: <#AIAssistantCoordinator#>)
//}
