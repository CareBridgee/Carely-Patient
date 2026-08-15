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
            ChatHeaderView(
                onDismiss: {
                    if let onDismiss = viewModel.onDismiss {
                        onDismiss()
                    } else {
                        dismiss()
                    }
                },
                onReset: {
                    viewModel.resetChat()
                }
            )

            messageList

            if let errorMessage = viewModel.errorMessage {
                errorBanner(message: errorMessage)
            }

            ChatInputBar(
                text: $viewModel.inputText,
                isLoading: viewModel.isLoading || viewModel.isResetting,
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
                    if viewModel.messages.isEmpty && !viewModel.isLoading {
                        emptyStateWelcome
                    }

                    ForEach(viewModel.messages) { message in
                        ChatMessageCell(
                            message: message,
                            onBookDraft: { draft in
                                viewModel.bookDraft(draft)
                            },
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

    // MARK: - Empty State Welcome

    private var emptyStateWelcome: some View {
        VStack(spacing: Spacing.s12) {
            ZStack {
                Circle()
                    .fill(Color.brandPrimary.opacity(0.1))
                    .frame(width: 60, height: 60)

                Image(systemName: "sparkles")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.brandPrimary)
            }
            .padding(.top, Spacing.s32)

            Text("How can I help you today?")
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(Color.primaryFont)

            Text("Describe symptoms or request care advice. I will help determine the right service for your health profile.")
                .carelyText(style: .bodyRegular, weight: .regular)
                .foregroundColor(Color.secondaryFont)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Spacing.s24)
        }
        .padding(.vertical, Spacing.s20)
        .frame(maxWidth: .infinity)
    }

    // MARK: - Error Banner

    private func errorBanner(message: String) -> some View {
        HStack(spacing: Spacing.s8) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(Color.onError)
                .font(.system(size: 16))

            Text(message)
                .carelyText(style: .caption, weight: .medium)
                .foregroundColor(Color.onError)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.error.opacity(0.85))
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


