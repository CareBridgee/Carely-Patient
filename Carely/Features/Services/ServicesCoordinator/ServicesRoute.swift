//
//  ServicesRoute.swift
//  Carely
//
//  Created by Mohamed Ayman on 22/07/2026.
//


import Foundation

// MARK: - ServicesRoute

enum ServicesRoute: Hashable {
    case serviceDetails(source: ServiceDetailsSource)
    case requestService
    case waitingForOffers(requestId: String)
    case OfferAccepted(request: ConfirmedOffer)
    case showQRCode(request: ConfirmedOffer)
    case nurseProfile(nurseId: String)
//    case activeVisit(ActiveVisit)
//    case chat(ActiveVisit)
//    case startVisitQR(ActiveVisit)
//    case finishVisitQR(ActiveVisit)
}
