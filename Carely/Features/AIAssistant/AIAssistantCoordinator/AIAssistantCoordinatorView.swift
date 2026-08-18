//
//  AIAssistantCoordinatorView.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import SwiftUI

struct AIAssistantCoordinatorView: View {
    let container: DIContainer
    @ObservedObject var coordinator: AIAssistantCoordinator
    @StateObject private var choosePatientViewModel: ChoosePatientViewModel

    init(container: DIContainer, coordinator: AIAssistantCoordinator) {
        self.container = container
        self.coordinator = coordinator
        _choosePatientViewModel = StateObject(wrappedValue: container.makeChoosePatientViewModel(
            onShowPatientDetails: { patientId in
                coordinator.viewProfiledetailsTapped(profileId: patientId)
            },
            onContinueWithAssessment: { patientId in
                coordinator.push(to: .aiAssistantChat(patientId: patientId))
            },
            onAddFamilyMember: {
                coordinator.addFamilyMemberTapped()
            },
            onDismiss: {
                coordinator.onBackClicked?()
            }
        ))
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ChoosePatientView(viewModel: choosePatientViewModel)
            .navigationDestination(for: AIAssistantRoute.self) { route in
                destination(for: route)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AIAssistantRoute) -> some View {
        switch route {
        case .aiAssistantChat(let patientId):
            AIChatView(
                viewModel: container.makeAIChatViewModel(
                    profileId: patientId,
                    onProceedToBooking: { draft in
                        coordinator.requestNowTapped(draft: draft, profileId: patientId)
                    },
                    onDismiss: {
                        coordinator.pop()
                    }
                )
            )
        case .addFamilyMember:
            AddFamilyMemberCoordinatorView(
                container: container,
                onFinish: {
                    coordinator.pop()
                },
                onCancel: {
                    coordinator.pop()
                }
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
                    }
                ),
                onAddFamilyMemberTapped: {
                    coordinator.push(to: .addFamilyMember)
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
                },
                onGoToHome: {
                    coordinator.goToHome()
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

        case .chat(let reservationId, let nurseName, let nurseImageUrl):
            ChatView(viewModel: container.makeChatViewModel(
                reservationId: reservationId,
                nurseName: nurseName,
                nurseImageUrl: nurseImageUrl
            ))
        }
    }
}
