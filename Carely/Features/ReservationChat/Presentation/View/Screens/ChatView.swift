//
//  ChatView.swift
//  Carely
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading messages...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.messages) { message in
                                ReservationChatMessageCell(
                                    message: message,
                                    isCurrentUser: message.senderUserId == viewModel.currentUserId
                                )
                                .id(message.id)
                            }
                        }
                        .padding(.top)
                    }
                    .onChange(of: viewModel.messages.count) {
                        guard let last = viewModel.messages.last else { return }

                        withAnimation {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                    .onAppear {
                        if let last = viewModel.messages.last {
                            proxy.scrollTo(last.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.horizontal)
            }
            
            // Input Bar
            HStack {
                TextField("Message...", text: $viewModel.newMessageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .padding()
                }
                .disabled(viewModel.newMessageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.bottom)
        }
        .navigationTitle("Chat")
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}
