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
    @StateObject private var allServiceViewModel: AllServiceViewModel

    init(container: DIContainer, coordinator: ServicesCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _allServiceViewModel = StateObject(wrappedValue: container.makeAllServiceViewModel(coordinator: coordinator))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            AllServiceView(viewModel: allServiceViewModel)
            .navigationDestination(for: ServicesRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: ServicesRoute) -> some View {
        switch route {
            
        case .serviceDetails(let id, let source):
            ServiceDetailsView(
                viewModel: container.makeServiceDetailsViewModel(serviceId: id, source: source, coordinator: coordinator)
            )

        case .requestService(let entryPoint, let preselectedServiceId, let aiDraft, let aiProfileId):
            CareRequestView(
                viewModel: container.makeCareRequestViewModel(
                    preselectedService: CareService.init(id: preselectedServiceId ?? "", title: "Loading...", icon: "syringe"),
                    entryPoint: entryPoint,
                    aiDraft: aiDraft,
                    aiProfileId: aiProfileId,
                    onSubmitted: { requestId, paymentMethod in
                                            coordinator.push(to: .waitingForOffers(requestId: requestId, paymentMethod: paymentMethod))
                    }),
                onEditProfileTapped: {
                    //
                },
                onAddFamilyMemberTapped: {
                    coordinator.push(to: .addFamilyMember)
                }
            )
        case .addFamilyMember:
            AddFamilyMemberCoordinatorView(
                container: container,
                onFinish: {
                    coordinator.pop()
                    coordinator.onAddFamilyMemberFromProfileFinished?()
                    coordinator.onAddFamilyMemberFromProfileFinished = nil
                },
                onCancel: {
                    coordinator.pop()
                    coordinator.onAddFamilyMemberFromProfileFinished = nil
                }
            )
        case .waitingForOffers(let requestId, let paymentMethod):
                OffersSearchingView(viewModel: container.makeOffersSearchingViewModel(
                    requestId: requestId,
                    paymentMethod: paymentMethod,
                    onOfferAccepted: { confirmedOffer in
                        container.activeVisitStore.setActiveVisit(confirmedOffer)
                        coordinator.push(to: .OfferAccepted(request: confirmedOffer))
                    },
                    onShowNurseProfile: { nurseId in
                        coordinator.push(to: .nurseProfile(nurseId: nurseId))
                    },
                    onSearchCanceled: {
                        coordinator.popToRoot()
                    }
                ))
            
        case .OfferAccepted(let request):
            let viewModel = container.makeOfferAcceptedViewModel(
                request: request,
                onShowQRCode: { req in
                    coordinator.push(to: .showQRCode(request: req))
                },
                onCancelRequest: {
                    coordinator.popToRequestForm()
                },
                onShowNurseProfile: { nurseId in
                    coordinator.push(to: .nurseProfile(nurseId: nurseId))
                },
                onMessageNurse: { reservationId in
                    coordinator.push(to: .chat(
                        reservationId: reservationId,
                        nurseName: request.nurse.fullName,
                        nurseImageUrl: request.nurse.profileImageUrl
                    ))
                },
                onVisitCompleted: {
                    coordinator.push(to: .visitCompleted(visitId: request.id))
                }
            )
            OfferAcceptedView(viewModel: viewModel)
            
        case .showQRCode(let request):
            let viewModel = container.makeArrivalQRCodeViewModel(
                serviceRequestId: request.id,
                qrCodeData: request.qrCodeData,
                referenceNumber: "#\(request.id.uppercased())",
                onClose: {
                    coordinator.pop()
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
        case .chat(let reservationId, let nurseName, let nurseImageUrl):
            ChatView(viewModel: container.makeChatViewModel(
                reservationId: reservationId,
                nurseName: nurseName,
                nurseImageUrl: nurseImageUrl
            ))
            .onAppear {
                coordinator.isInsideChat = true
            }
            .onDisappear {
                coordinator.isInsideChat = false
            }

        case .choosePatient:
            ChoosePatientView(
                viewModel: container.makeChoosePatientViewModel(
                    onContinueWithAssessment: { patientId in
                        coordinator.push(to: .aiChat(patientId: patientId))
                    },
                    onAddFamilyMember: {
                        coordinator.push(to: .addFamilyMember)
                    }
                ),
                onBackTapped: {
                    coordinator.pop()
                }
            )

        case .aiChat(let patientId):
            AIChatView(
                viewModel: container.makeAIChatViewModel(
                    profileId: patientId,
                    onProceedToBooking: { draft in
                        coordinator.popToRoot()
                        coordinator.openRequestFromAIAssistant(draft: draft, profileId: patientId)
                    },
                    onDismiss: {
                        coordinator.pop()
                    }
                )
            )
        }
    }
}
