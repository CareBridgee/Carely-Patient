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
            showBackButton: false,
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .blur(radius: viewModel.isLoading ? 3 : 0)
        .onAppear { viewModel.onAppear() }
    }
 
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.items.isEmpty {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s16) {
                    ForEach(0..<4, id: \.self) { _ in
                        HStack(alignment: .top, spacing: Spacing.s16) {
                            EtmaenSkeletonRect(width: 48, height: 48, radius: Radius.r16)
                            
                            VStack(alignment: .leading, spacing: Spacing.s4) {
                                HStack {
                                    EtmaenSkeletonRect(width: 120, height: 16, radius: Radius.r8)
                                    Spacer()
                                    EtmaenSkeletonRect(width: 70, height: 20, radius: Radius.r12)
                                }
                                
                                EtmaenSkeletonRect(width: 140, height: 14, radius: Radius.r8)
                                
                                HStack(spacing: Spacing.s4) {
                                    EtmaenSkeletonCircle(size: 12)
                                    EtmaenSkeletonRect(width: 100, height: 12, radius: Radius.r8)
                                }
                            }
                        }
                        .padding(Spacing.s16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle.carely(Radius.r24))
                        .carelyShadow(.sm)
                    }
                }
                .padding(Spacing.s16)
                Spacer()
                ProgressView()
                Spacer()
            }
        } else if let loadError = viewModel.loadError, viewModel.items.isEmpty {
            ErrorStateView(error: loadError) {
                viewModel.loadHistory()
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
