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
                content
            }
        }
        .careConnectNavigationBar(
            title: "History",
            showBackButton: true,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .blur(radius: viewModel.isLoading ? 3 : 0)
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadHistory() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
 
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.items.isEmpty {
            ScrollView(showsIndicators: false) {
                EtmaenListSkeleton(count: 3)
                    .padding(Spacing.s16)
            }
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
