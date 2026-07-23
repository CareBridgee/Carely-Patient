//
//  ServicesCoordinatorView.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//


import SwiftUI

// MARK: - ServicesCoordinatorView

struct ServicesCoordinatorView: View {

    let container: DIContainer
    @ObservedObject var coordinator: ServicesCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            AllServiceView(viewModel: container.makeAllServiceViewModel(coordinator: coordinator))
            .navigationDestination(for: ServicesRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: ServicesRoute) -> some View {
        switch route {
            
        case .serviceDetails(let source):
            ServiceDetailsView(
                viewModel: container.makeServiceDetailsViewModel(serviceId: "injection",source: source,coordinator: coordinator)
            )

        case .requestService:
            CareRequestView(
                viewModel: container.makeCareRequestViewModel(
                    preselectedService: CareService.init(id: "String", title: "Injection", icon: "syringe"),
                    entryPoint: CareRequestEntryPoint.aiChat,
                    onSubmitted: {
                        coordinator.push(.waitingForOffers)
                    }),
                onEditProfileTapped: {
                    //
                }
            )

        case .waitingForOffers:
            OffersSearchingView(viewModel: container.makeOffersSearchingViewModel())
//
//        case .activeVisit(let visit):
//            ActiveVisitView(
//                visit: visit,
//                onOpenChat: { coordinator.openChat(for: visit) },
//                onStartVisit: { coordinator.openStartVisitQR(for: visit) },
//                onFinishVisit: { coordinator.openFinishVisitQR(for: visit) }
//            )
//
//        case .chat(let visit):
//            ChatView(visit: visit)
//
//        case .startVisitQR(let visit):
//            StartVisitQRView(visit: visit)
//
//        case .finishVisitQR(let visit):
//            FinishVisitQRView(visit: visit)
        }
    }
}
