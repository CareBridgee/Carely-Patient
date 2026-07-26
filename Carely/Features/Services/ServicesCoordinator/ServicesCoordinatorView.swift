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

        case .requestService(let entryPoint):
            CareRequestView(
                viewModel: container.makeCareRequestViewModel(
                    preselectedService: CareService.init(id: "String", title: "Injection", icon: "syringe"),
                    entryPoint: entryPoint,
                    onSubmitted: { requestId in
                        coordinator.push(to: .waitingForOffers(requestId: requestId))
                    }),
                onEditProfileTapped: {
                    //
                }
            )

        case .waitingForOffers(let requestId):
            OffersSearchingView(viewModel: container.makeOffersSearchingViewModel(
                requestId: requestId,
                onOfferAccepted: { ConfirmedOffer in
                    coordinator.push(to: .OfferAccepted(request: ConfirmedOffer))
                },
                onShowNurseProfile: { nurseId in
                    coordinator.push(to: .nurseProfile(nurseId: nurseId))
                }
            ))
            
        case .OfferAccepted(let request):
            let viewModel = container.makeOfferAcceptedViewModel(
                request: request,
                onShowQRCode: { req in
                    coordinator.push(to: .showQRCode(request: req))
                },
                onCancelRequest: {
                    coordinator.popToRoot()
                },
                onShowNurseProfile: { nurseId in
                    coordinator.push(to: .nurseProfile(nurseId: nurseId))
                }
            )
            OfferAcceptedView(viewModel: viewModel)
            
        case .showQRCode(let request):
            let viewModel = container.makeArrivalQRCodeViewModel(
                qrCodeData: request.qrCodeData,
                referenceNumber: "#\(request.id.uppercased())",
                onClose: {
                    coordinator.push(to: .visitCompleted(visitId: request.id))
                }
            )
            ArrivalQRCodeView(viewModel: viewModel)
            
        case .nurseProfile(let nurseId):
            let viewModel = container.makeNurseProfileViewModel(nurseId: nurseId)
            NurseProfileView(viewModel: viewModel)

        case .visitCompleted(let visitId):
            VisitCompletedView(
                viewModel: container.makeVisitCompletedViewModel(
                    visitId: visitId,
                    onFinished: {
                        coordinator.popToRoot()
                    }
                )
            )
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
