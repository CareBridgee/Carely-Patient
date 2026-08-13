//
//  AIChatViewModel.swift
//  Carely
//
//  Created by Mohamed Ayman on 31/07/2026.
//

import Foundation

@MainActor
final class AIChatViewModel: ObservableObject {

    // MARK: - Published State

    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var isResetting: Bool = false
    @Published var errorMessage: String? = nil
    @Published var latestDraft: ReservationDraft? = nil

    // MARK: - Properties & Callbacks

    let profileId: String
    let emergencyPhoneNumber: String
    var onDismiss: (() -> Void)?
    var onProceedToBooking: ((ReservationDraft) -> Void)?
    // MARK: - Dependencies

    private let sendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol
    private let resetAIChatUseCase: ResetAIChatUseCaseProtocol

    // MARK: - Init

    init(
        profileId: String,
        sendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol,
        resetAIChatUseCase: ResetAIChatUseCaseProtocol,
        emergencyPhoneNumber: String = EmergencyConfiguration.phoneNumber,
        onDismiss: (() -> Void)? = nil,
        onProceedToBooking: ((ReservationDraft) -> Void)? = nil
    ) {
        self.profileId = profileId
        self.sendAIChatMessageUseCase = sendAIChatMessageUseCase
        self.resetAIChatUseCase = resetAIChatUseCase
        self.emergencyPhoneNumber = emergencyPhoneNumber
        self.onDismiss = onDismiss
        self.onProceedToBooking = onProceedToBooking
    }

    // MARK: - Actions

    func sendMessage() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = ChatMessage(
            sender: .user,
            content: .text(trimmed),
            timestamp: currentTimeString(),
            isSeen: false
        )
        messages.append(userMessage)
        inputText = ""
        errorMessage = nil

        isLoading = true
        Task {
            defer { isLoading = false }
            do {
                let response = try await sendAIChatMessageUseCase.execute(
                    profileId: profileId,
                    message: trimmed
                )
                handleChatTurnResponse(response)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func resetChat() {
        guard !isResetting else { return }
        isResetting = true
        errorMessage = nil

        Task {
            defer { isResetting = false }
            do {
                try await resetAIChatUseCase.execute(profileId: profileId)
                messages.removeAll()
                latestDraft = nil
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    func bookDraft(_ draft: ReservationDraft) {
        onProceedToBooking?(draft)
    }

    // MARK: - Response Handling

    private func handleChatTurnResponse(_ response: ChatTurnResponse) {
        let previousDraft = latestDraft

        switch response.messageType {

        case .urgent:
            appendAIText(response.reply)
            let advice = response.urgency?.advice
                ?? "Please call emergency services immediately or visit the nearest hospital."
            appendMessage(.emergencyCard(advice: advice, phoneNumber: emergencyPhoneNumber))

        case .confirm:
            appendAIText(response.reply)
            if let draft = response.draft, draft != previousDraft {
                latestDraft = draft
                appendMessage(.draftCard(draft))
            }

        case .text, .input, .error:
            appendAIText(response.reply)
        }
    }

    // MARK: - Helpers

    private func appendAIText(_ text: String) {
        appendMessage(.text(text))
    }

    private func appendMessage(_ content: MessageContent) {
        let message = ChatMessage(
            sender: .ai,
            content: content,
            timestamp: currentTimeString()
        )
        messages.append(message)
    }

    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}
