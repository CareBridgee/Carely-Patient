//
//  AIAssistantRoute.swift
//  Carely
//
//  Created by Mona Zarea on 24/07/2026.
//

import Foundation

enum AIAssistantRoute: Hashable {
    case aiAssistantChat(patientId: String)
    case addFamilyMember
    case requestService(entryPoint: CareRequestEntryPoint, preselectedServiceId: String? = nil, aiDraft: ReservationDraft? = nil, aiProfileId: String? = nil)
    case waitingForOffers(requestId: String, paymentMethod: String)
    case OfferAccepted(request: ConfirmedOffer)
    case showQRCode(request: ConfirmedOffer)
    case nurseProfile(nurseId: String)
    case visitCompleted(visitId: String)
    case chat(reservationId: String, nurseName: String? = nil, nurseImageUrl: String? = nil)
}
