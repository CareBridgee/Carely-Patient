//
//  AIChatView.swift
//  Carely
//

import SwiftUI

// MARK: - Screen

struct AIChatView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AIChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            ChatHeaderView()

            messageList

            if let errorMessage = viewModel.errorMessage {
                errorBanner(message: errorMessage)
            }

            ChatInputBar(
                text: $viewModel.inputText,
                isLoading: viewModel.isLoading,
                onSend: viewModel.sendMessage
            )
            
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    // MARK: - Message List

    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: Spacing.s16) {
                    ForEach(viewModel.messages) { message in
                        ChatMessageCell(
                            message: message,
                            onPrimaryRecommendationAction: { _ in },
                            onSecondaryRecommendationAction: { _ in }
                        )
                        .id(message.id)
                    }

                    if viewModel.isLoading {
                        TypingIndicator()
                            .id("typing-indicator")
                    }
                }
                .padding(.horizontal, Spacing.s20)
                .padding(.top, Spacing.s16)
                .padding(.bottom, Spacing.s20)
            }
            .onChange(of: viewModel.messages.count) {
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isLoading) {
                scrollToBottom(proxy: proxy)
            }
        }
    }

    // MARK: - Error Banner

    private func errorBanner(message: String) -> some View {
        HStack(spacing: Spacing.s8) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 16))

            Text(message)
                .carelyText(style: .caption, weight: .medium)
                .foregroundColor(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.85))
    }

    // MARK: - Helpers

    private func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
            if viewModel.isLoading {
                proxy.scrollTo("typing-indicator", anchor: .bottom)
            } else if let lastId = viewModel.messages.last?.id {
                proxy.scrollTo(lastId, anchor: .bottom)
            }
        }
    }
}

// MARK: - Typing Indicator

private struct TypingIndicator: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: Spacing.s4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.secondaryFont.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .scaleEffect(animate ? 1.0 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(Double(index) * 0.15),
                        value: animate
                    )
            }
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s12)
        .background(Color.surface)
        .clipShape(ChatBubbleShape(radius: 18, corners: [.topLeft, .topRight, .bottomRight]))
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear { animate = true }
    }
}

// MARK: - Preview

#Preview {
    // Mock use case for Xcode Previews — no network needed
    struct MockSendAIChatMessageUseCase: SendAIChatMessageUseCaseProtocol {
        func execute(message: String) async throws -> AIChatReply {
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return AIChatReply(text: "Hello! I'm your AI health assistant. How can I help you today?")
        }
    }

    let viewModel = AIChatViewModel(sendAIChatMessageUseCase: MockSendAIChatMessageUseCase())
    // Seed with a sample message so the preview isn't empty
    viewModel.messages = [
        ChatMessage(
            sender: .ai,
            content: .text("Hello! Based on your health profile, I see you're managing Hypertension. How can I assist you today?"),
            timestamp: "Just now"
        )
    ]
    return AIChatView(viewModel: viewModel)
}
