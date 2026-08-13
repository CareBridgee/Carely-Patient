//
//  OffersSearchingHubServices.swift
//  Carely
//
//  Created by Mona Zarea on 22/07/2026.
//

import Foundation

protocol OffersSearchingHubServicesProtocol {
    var onOfferReceived: ((NurseOffer) -> Void)? { get set }
    var onOfferCanceled: ((String) -> Void)? { get set }
    var onOfferConfirmed: ((NurseOffer) -> Void)? { get set }
    var onRequestCanceled: (() -> Void)? { get set }
    
    func connect()
    func disconnect()
    func acceptOffer(offerId: String)
    func declineOffer(offerId: String)
    func cancelServiceRequest(serviceRequestId: String)
}

final class OffersSearchingSocketDataSource: OffersSearchingHubServicesProtocol {
    var onOfferReceived: ((NurseOffer) -> Void)?
    var onOfferCanceled: ((String) -> Void)?
    var onOfferConfirmed: ((NurseOffer) -> Void)?
    var onRequestCanceled: (() -> Void)?
    
    private let socketClient: SocketClientProtocol
    private let serviceRequestId: String
    private let decoder = JSONDecoder()
    private var hasSubscribed = false
    
    init(socketClient: SocketClientProtocol, serviceRequestId: String) {
        self.socketClient = socketClient
        self.serviceRequestId = serviceRequestId
        self.setupSocketEvents()
    }
    
    private func setupSocketEvents() {
            let key = "Offers_\(ObjectIdentifier(self))"
            
            socketClient.onConnectedListeners[key] = { [weak self] in
                guard let self = self else { return }
                let topic = "/topic/reservation/\(self.serviceRequestId)"
                print("[Socket Data Source] Connected! Subscribing to: \(topic)")
                self.socketClient.subscribe(to: topic)
                self.hasSubscribed = true
            }

            socketClient.onMessageReceivedListeners[key] = { [weak self] destination, body in
                guard let self = self else { return }
                print("[Socket Data Source] Received message on destination: \(destination)")
                if destination.contains("/topic/reservation/\(self.serviceRequestId)") {
                    self.handleMessage(body: body)
                } else {
                    print("[Socket Data Source] Destination mismatch. Expected to contain: /topic/reservation/\(self.serviceRequestId)")
                }
            }
        }

        func disconnect() {
            let key = "Offers_\(ObjectIdentifier(self))"
                    
                    if hasSubscribed {
                        socketClient.unsubscribe(from: "/topic/reservation/\(serviceRequestId)")
                        hasSubscribed = false
                    }
                    
                    socketClient.onConnectedListeners.removeValue(forKey: key)
                    socketClient.onMessageReceivedListeners.removeValue(forKey: key)
                    }
    
    deinit {
        disconnect()
    }
    
    func connect() {
        socketClient.connect()
    }
    
    func acceptOffer(offerId: String) {
        let payload = "{\"offerId\":\"\(offerId)\"}"
        socketClient.send(to: "/app/reservation/offer/accept", body: payload, headers: ["content-type": "application/json"])
    }
    
    func declineOffer(offerId: String) {
        let payload = "{\"offerId\":\"\(offerId)\"}"
        socketClient.send(to: "/app/reservation/offer/reject", body: payload, headers: ["content-type": "application/json"])
    }
    
    func cancelServiceRequest(serviceRequestId: String) {
        let payload = "{\"serviceRequestId\":\"\(serviceRequestId)\"}"
        socketClient.send(to: "/app/reservation/cancel", body: payload, headers: ["content-type": "application/json"])
    }
    

    
    private struct EventTypeDTO: Decodable {
        let type: String
    }
    
    private func handleMessage(body: String) {
        print("[Socket Data Source] Received raw message body: \(body)")
        guard let data = body.data(using: .utf8) else { return }
        
        do {
            let baseEvent = try decoder.decode(EventTypeDTO.self, from: data)
            print("[Socket Data Source] Event type parsed: \(baseEvent.type)")
            
            switch baseEvent.type.uppercased() {
            case "OFFER_CREATED", "OFFER_UPDATED", "OFFER_COUNTERED":
                let event = try decoder.decode(ReservationEventDTO.self, from: data)
                if let offerData = event.data {
                    let firstName = offerData.nurse.firstName ?? ""
                    let lastName = offerData.nurse.lastName ?? ""
                    let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                    
                    let nurseOffer = NurseOffer(
                        id: offerData.id,
                        name: fullName.isEmpty ? "Unknown Nurse" : fullName,
                        title: "RN",
                        price: offerData.proposedPrice,
                        rating: offerData.nurse.ratingAvg ?? 0.0,
                        reviewsCount: offerData.nurse.totalReviews ?? 0,
                        distance: offerData.distanceKm ?? 0.0,
                        imageLink: offerData.nurse.profileImageUrl ?? "",
                        specialty: offerData.serviceTypeName ?? "General",
                        estimatedArrival: offerData.proposedTime ?? "TBD"
                    )
                    print("[Socket Data Source] Offer successfully parsed: \(nurseOffer)")
                    DispatchQueue.main.async {
                        self.onOfferReceived?(nurseOffer)
                    }
                } else {
                    print("[Socket Data Source] Warning: event.data is nil for type \(baseEvent.type)")
                }
                
            case "OFFER_ACCEPTED":
                let event = try decoder.decode(ReservationEventDTO.self, from: data)
                if let offerData = event.data {
                    let firstName = offerData.nurse.firstName ?? ""
                    let lastName = offerData.nurse.lastName ?? ""
                    let fullName = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
                    
                    let nurseOffer = NurseOffer(
                        id: offerData.id,
                        name: fullName.isEmpty ? "Unknown Nurse" : fullName,
                        title: "RN",
                        price: offerData.proposedPrice,
                        rating: offerData.nurse.ratingAvg ?? 0.0,
                        reviewsCount: offerData.nurse.totalReviews ?? 0,
                        distance: offerData.distanceKm ?? 0.0,
                        imageLink: offerData.nurse.profileImageUrl ?? "",
                        specialty: offerData.serviceTypeName ?? "General",
                        estimatedArrival: offerData.proposedTime ?? "TBD"
                    )
                    print("[Socket Data Source] Offer successfully parsed as ACCEPTED: \(nurseOffer)")
                    DispatchQueue.main.async {
                        self.onOfferConfirmed?(nurseOffer)
                    }
                } else {
                    print("[Socket Data Source] Warning: event.data is nil for type \(baseEvent.type)")
                }
                
            case "OFFER_WITHDRAWN", "OFFER_REJECTED":
                let referenceEvent = try decoder.decode(OfferReferenceEventDTO.self, from: data)
                if let offerId = referenceEvent.data?.offerId {
                    DispatchQueue.main.async {
                        self.onOfferCanceled?(offerId)
                    }
                }
                
            case "REQUEST_CANCELLED":
                DispatchQueue.main.async {
                    self.onRequestCanceled?()
                }
                
            default:
                print("[Socket Data Source] Ignored event type: \(baseEvent.type)")
                break // Ignored event
            }
        } catch {
            print("[Socket Data Source] Error decoding message: \(error)")
        }
    }
}

private struct OfferReferenceEventDTO: Decodable {
    let data: OfferReferenceDTO?
}
