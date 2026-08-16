//
//  ChatView.swift
//  Carely
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: Spacing.s0) {
            chatHeader

            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if viewModel.messages.isEmpty {
                emptyState
            } else {
                messagesList
            }

            inputArea
        }
        .background(Color.backGround.ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .errorToast($viewModel.errorMessage)
    }
    
    // MARK: - Header
    private var chatHeader: some View {
        HStack(spacing: Spacing.s12) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "arrow.left")
                    .font(.system(size: IconSize.s20, weight: .semibold))
                    .foregroundColor(.primaryFont)
            }
            
            ZStack(alignment: .bottomTrailing) {
                if let urlString = viewModel.nurseImageUrl, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        default:
                            Circle().fill(Color.surfaceVariant)
                                .overlay(
                                    Image(systemName: "person.fill")
                                        .foregroundColor(.hint)
                                )
                        }
                    }
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                } else {
                    Circle().fill(Color.surfaceVariant)
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(.hint)
                        )
                }
                
                Circle()
                    .fill(Color.success)
                    .frame(width: 10, height: 10)
                    .overlay(Circle().stroke(Color.surface, lineWidth: Spacing.s2))
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(nurseName)
                    .carelyText(style: .bodyLarge, weight: .bold)
                    .foregroundColor(.primaryFont)
                Text("Active Now")
                    .carelyText(style: .caption, weight: .regular)
                    .foregroundColor(.secondaryFont)
            }
            
            Spacer(minLength: Spacing.s0)
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s8)
        .background(Color.surface)
        .shadow(color: Color.black.opacity(0.04), radius: 3, y: 1)
    }

    private var nurseName: String {
        if let name = viewModel.nurseName, !name.isEmpty {
            return name
        }
        return viewModel.messages.first(where: { !viewModel.isCurrentUser(message: $0) })?.senderName ?? "Nurse"
    }

    // MARK: - Messages List
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Spacing.s16) {
                    Text("Today")
                        .carelyText(style: .caption, weight: .medium)
                        .padding(.horizontal, Spacing.s12)
                        .padding(.vertical, Spacing.s4)
                        .background(Color.surfaceVariant)
                        .clipShape(Capsule())
                        .padding(.top, Spacing.s16)
                        .padding(.bottom, Spacing.s8)

                    ForEach(viewModel.messages) { message in
                        messageBubble(for: message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal, Spacing.s16)
                .padding(.bottom, Spacing.s24)
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastId = viewModel.messages.last?.id {
                    withAnimation { proxy.scrollTo(lastId, anchor: .bottom) }
                }
            }
            .onAppear {
                if let lastId = viewModel.messages.last?.id {
                    proxy.scrollTo(lastId, anchor: .bottom)
                }
            }
        }
    }
    
    // MARK: - Message Bubble
    private func messageBubble(for message: ChatMessageResponse) -> some View {
        let isMe = viewModel.isCurrentUser(message: message)
        let timeString = viewModel.formatTime(dateString: message.createdAt)
        
        return VStack(alignment: isMe ? .trailing : .leading, spacing: Spacing.s4) {
            // Text Bubble
            Text(message.content)
                .carelyText(style: .bodyRegular, weight: .regular)
                .foregroundColor(isMe ? .onPrimary : .primaryFont)
                .padding(.horizontal, Spacing.s16)
                .padding(.vertical, Spacing.s12)
                .background(isMe ? Color.brandPrimary : Color.surfaceVariant)
                .clipShape(RoundedRectangle.carely(Radius.r16))
            
            // Time & Status below the bubble
            HStack(spacing: Spacing.s4) {
                Text(timeString)
                    .carelyText(style: .caption, weight: .regular)
                    .foregroundColor(.secondaryFont)
                
                if isMe {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: IconSize.s12))
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(.horizontal, Spacing.s4)
        }
        .frame(maxWidth: .infinity, alignment: isMe ? .trailing : .leading)
    }

    // MARK: - Input Area
    private var inputArea: some View {
        HStack(spacing: Spacing.s12) {
            TextField("Type a message...", text: $viewModel.newMessageText, axis: .vertical)
                .carelyText(style: .bodyRegular, weight: .regular)
                .padding(.horizontal, Spacing.s16)
                .padding(.vertical, Spacing.s12)
                .background(Color.surfaceVariant)
                .clipShape(Capsule())
                .lineLimit(1...4)
            
            Button(action: {
                viewModel.sendMessage()
            }) {
                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: Spacing.s48, height: Spacing.s48)
                    .overlay(
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: IconSize.s20))
                            .foregroundColor(.onPrimary)
                    )
            }
            .disabled(viewModel.newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity(viewModel.newMessageText.isEmpty ? 0.6 : 1.0)
        }
        .padding(.horizontal, Spacing.s16)
        .padding(.vertical, Spacing.s12)
        .background(Color.surface)
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: Spacing.s12) {
            Spacer()
            Image(systemName: "bubble.left.and.bubble.right")
                .resizable()
                .scaledToFit()
                .frame(width: IconSize.s32, height: IconSize.s32)
                .foregroundColor(.hint)
            Text("No messages yet")
                .carelyText(style: .bodyLarge, weight: .semiBold)
                .foregroundColor(.primaryFont)
            Spacer()
        }
    }

    private var chatSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s16) {
                HStack {
                    EtmaenSkeletonRect(width: 180, height: 44, radius: Radius.r16)
                    Spacer()
                }
                HStack {
                    Spacer()
                    EtmaenSkeletonRect(width: 220, height: 56, radius: Radius.r16)
                }
                HStack {
                    EtmaenSkeletonRect(width: 150, height: 40, radius: Radius.r16)
                    Spacer()
                }
                HStack {
                    Spacer()
                    EtmaenSkeletonRect(width: 190, height: 48, radius: Radius.r16)
                }
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s16)
        }
    }
}
