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
    @Published var errorMessage: String? = nil

    // MARK: - Dependencies

    private let sendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol

    // MARK: - Init

    init(sendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol) {
        self.sendAIChatMessageUseCase = sendAIChatMessageUseCase
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
                let reply = try await sendAIChatMessageUseCase.execute(message: trimmed)
                let aiMessage = ChatMessage(
                    sender: .ai,
                    content: .text(reply.text),
                    timestamp: currentTimeString()
                )
                messages.append(aiMessage)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Helpers

    private func currentTimeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: Date())
    }
}
