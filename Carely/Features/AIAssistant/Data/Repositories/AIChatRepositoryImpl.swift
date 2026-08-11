//
//  AIChatRepositoryImpl.swift
//  Carely
//

import Foundation

final class AIChatRepositoryImpl: AIChatRepositoryProtocol {
    private let service: AIChatServiceProtocol

    init(service: AIChatServiceProtocol) {
        self.service = service
    }

    func sendMessage(profileId: String, message: String) async throws -> ChatTurnResponse {
        do {
            let dto = try await service.sendMessage(profileId: profileId, message: message)
            print("[AI CHAT LOG] Received Response: messageType=\(dto.messageType.rawValue), reply=\"\(dto.reply)\"")
            if let draft = dto.draft {
                print("[AI CHAT LOG] Reservation Draft: serviceTypeId=\(draft.serviceTypeId ?? "nil"), serviceTypeName=\(draft.serviceTypeName ?? "nil"), preferredDate=\(draft.preferredDate ?? "nil"), preferredTime=\(draft.preferredTime ?? "nil"), complete=\(draft.complete ?? false) Desc : \(draft.serviceDescription ?? "nil")")
            }
            if let urgency = dto.urgency {
                print("[AI CHAT LOG] Urgency Signal: urgent=\(urgency.urgent ?? false), level=\(urgency.level ?? "nil"), advice=\(urgency.advice ?? "nil")")
            }
            return mapToDomain(dto: dto)
        } catch let error as NetworkError {
            switch error {
            case .noInternetConnection, .timeout:
                throw AIChatError.network
            case .unauthorized, .sessionExpired:
                throw error
            case .server(let code, let message):
                if code == 429 {
                    throw AIChatError.rateLimited
                } else if code == 503 {
                    throw AIChatError.serviceUnavailable
                } else if code == 400 {
                    throw AIChatError.validation(message ?? "Invalid request. Please check your message.")
                } else {
                    throw AIChatError.server(message ?? "Server error (\(code)). Please try again.")
                }
            default:
                throw AIChatError.network
            }
        } catch {
            throw AIChatError.unknown
        }
    }

    func resetChat(profileId: String) async throws {
        do {
            try await service.resetChat(profileId: profileId)
        } catch let error as NetworkError {
            switch error {
            case .noInternetConnection, .timeout:
                throw AIChatError.network
            case .unauthorized, .sessionExpired:
                throw error
            case .server(_, let message):
                throw AIChatError.server(message ?? "Unable to reset chat session.")
            default:
                throw AIChatError.network
            }
        } catch {
            throw AIChatError.unknown
        }
    }

    // MARK: - Private Mapping

    private func mapToDomain(dto: ChatTurnResponseDTO) -> ChatTurnResponse {
        let messageType = mapMessageType(dto.messageType)

        let draft: ReservationDraft?
        if let draftDTO = dto.draft {
            draft = ReservationDraft(
                serviceTypeId: draftDTO.serviceTypeId,
                serviceTypeName: draftDTO.serviceTypeName,
                preferredDate: draftDTO.preferredDate,
                preferredTime: draftDTO.preferredTime,
                serviceDescription: draftDTO.serviceDescription,
                complete: draftDTO.complete ?? false
            )
        } else {
            draft = nil
        }

        let urgency: UrgencySignal?
        if let urgencyDTO = dto.urgency {
            urgency = UrgencySignal(
                urgent: urgencyDTO.urgent ?? false,
                level: urgencyDTO.level,
                advice: urgencyDTO.advice ?? ""
            )
        } else {
            urgency = nil
        }

        return ChatTurnResponse(
            messageType: messageType,
            reply: dto.reply,
            draft: draft,
            urgency: urgency
        )
    }

    private func mapMessageType(_ dtoType: ChatMessageTypeDTO) -> ChatMessageType {
        switch dtoType {
        case .text: return .text
        case .input: return .input
        case .confirm: return .confirm
        case .urgent: return .urgent
        case .error: return .error
        }
    }
}

