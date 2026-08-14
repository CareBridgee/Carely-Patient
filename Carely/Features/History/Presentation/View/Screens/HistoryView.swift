//
//  HistoryView.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
 
    init(viewModel: HistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
 
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
 
            VStack(spacing: Spacing.s20) {
                topBar
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s8)
 
                content
            }
        }
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadHistory() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
 
    private var topBar: some View {
        HStack {
            Button {
                viewModel.backTapped()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.brandPrimary)
                    .frame(width: 40, height: 40)
            }
 
            Spacer()
 
            Text("History")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
 
            Spacer()
 
            Color.clear.frame(width: 40, height: 40)
        }
    }
 
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.items.isEmpty {
            Spacer()
            ProgressView()
            Spacer()
        } else if viewModel.items.isEmpty {
            Spacer()
            EmptyHistoryView(onExploreServices: viewModel.exploreServicesTapped)
            Spacer()
        } else {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s16) {
                    ForEach(viewModel.items) { item in
                        HistoryItemCard(item: item) {
                            viewModel.itemTapped(item)
                        }
                    }
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s64)
            }
        }
    }
}
