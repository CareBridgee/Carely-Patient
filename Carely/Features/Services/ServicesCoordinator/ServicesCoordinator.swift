//
//  ServicesCoordinator.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//

import Foundation
import SwiftUI

//// MARK: - ServicesCoordinator
//
//@MainActor
//final class ServicesCoordinator: ObservableObject {
//    
//    @Published var path = NavigationPath()
//
//    // MARK: - Cross-Tab Entry Points
//    var onBackClicked : (() -> Void)?
//    
//    func openServiceFromHome() {
//        path.append(ServicesRoute.serviceDetails(source: .home))
//    }
//    func openRequestFromAIAssistant(){
//        path.append(ServicesRoute.requestService(entryPoint: .aiChat))
//    }
//
//    func onBackTabbed(){
//        onBackClicked?()
//    }
////    func openActiveVisit() {
////        path = NavigationPath()
////        path.append(ServicesRoute.requestService)
////    }
//
//    // MARK: - Internal Navigation
//
//    func push(_ route: ServicesRoute) {
//        path.append(route)
//    }
//
//    func pop() {
//        guard !path.isEmpty else { return }
//        path.removeLast()
//    }
//
//    func popToRoot() {
//        path.removeLast(path.count)
//    }
//
//    // MARK: - Flow-Specific Convenience
//
////    func requestServiceTapped(for service: Service) {
////        push(.requestService(service))
////    }
////
////    func offerAccepted(for service: Service, visit: ActiveVisit) {
////        // Replace Waiting & Offers with Active Visit rather than stacking
////        // on top of it - the user shouldn't be able to navigate "back" to
////        // a waiting screen once a visit has started.
////        pop()
////        push(.activeVisit(visit))
////    }
////
////    func openChat(for visit: ActiveVisit) {
////        push(.chat(visit))
////    }
////
////    func openStartVisitQR(for visit: ActiveVisit) {
////        push(.startVisitQR(visit))
////    }
////
////    func openFinishVisitQR(for visit: ActiveVisit) {
////        push(.finishVisitQR(visit))
////    }
//}
//



@MainActor
final class ServicesCoordinator: AppRouterProtocol {
    typealias Route = ServicesRoute
    
    @Published var path = NavigationPath()
    @Published var isInsideChat: Bool = false
    var onBackClicked: (() -> Void)?
    var onAddFamilyMemberFromProfileFinished: (() -> Void)?
    var onOpenAIAssistant: (() -> Void)?
    
    func openServiceFromHome(id: String) {
        push(to: .serviceDetails(id: id, source: .home))
    }
    
    func openAIAssistant() {
        push(to: .choosePatient)
    }
   

    func openRequestFromAIAssistant(draft: ReservationDraft? = nil, profileId: String? = nil) {
        push(to: .requestService(entryPoint: .aiChat, aiDraft: draft, aiProfileId: profileId))
    }
    
    func openActiveVisit(offer: ConfirmedOffer) {
        popToRoot()
        push(to: .OfferAccepted(request: offer))
    }

    func popToRequestForm() {
        if path.count >= 2 {
            path.removeLast(2)
        } else {
            popToRoot()
        }
    }
}
