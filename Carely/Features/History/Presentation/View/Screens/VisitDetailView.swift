//
//  VisitDetailView.swift
//  Carely
//
//  Created by Mina on 14/08/2026.
//

import SwiftUI
 
struct VisitDetailView: View {
    @StateObject private var viewModel: VisitDetailViewModel
    var onBackTapped: () -> Void = {}
 
    init(viewModel: VisitDetailViewModel, onBackTapped: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onBackTapped = onBackTapped
    }
 
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
 
            VStack(spacing: Spacing.s20) {
                content
            }
        }
        .careConnectNavigationBar(
            title: "Visit Details",
            showBackButton: true,
            onBackTapped: onBackTapped
        )
        .onAppear { viewModel.onAppear() }
    }
 
    @ViewBuilder
    private var content: some View {
        if let detail = viewModel.detail {
            ScrollView(showsIndicators: false) {
                VStack(spacing: Spacing.s24) {
                    statusHeader(detail)
                    visitDetailsCard(detail)
                    careProviderCard(detail)
                    if let description = detail.description, !description.isEmpty {
                        descriptionCard(description)
                    }
                }
                .padding(Spacing.s16)
                .padding(.bottom, Spacing.s32)
            }
        } else if viewModel.isLoading {
            visitDetailSkeletonView
        } else if let loadError = viewModel.loadError {
            ErrorStateView(error: loadError) {
                viewModel.loadDetail()
            }
        } else {
            Spacer()
        }
    }

    private var visitDetailSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s24) {
                // Status Header Skeleton
                VStack(spacing: Spacing.s16) {
                    EtmaenSkeletonCircle(size: 96)
                    EtmaenSkeletonRect(width: 180, height: 22, radius: Radius.r8)
                    EtmaenSkeletonRect(width: 100, height: 24, radius: Radius.r12)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, Spacing.s16)

                // Visit Details Card Skeleton
                VStack(alignment: .leading, spacing: Spacing.s20) {
                    EtmaenSkeletonRect(width: 110, height: 14, radius: Radius.r8)
                    
                    VStack(spacing: Spacing.s16) {
                        ForEach(0..<3, id: \.self) { _ in
                            HStack(spacing: Spacing.s12) {
                                EtmaenSkeletonCircle(size: 32)
                                VStack(alignment: .leading, spacing: Spacing.s4) {
                                    EtmaenSkeletonRect(width: 60, height: 12, radius: Radius.r8)
                                    EtmaenSkeletonRect(width: 120, height: 14, radius: Radius.r8)
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)

                // Care Provider Card Skeleton
                VStack(alignment: .leading, spacing: Spacing.s16) {
                    EtmaenSkeletonRect(width: 110, height: 14, radius: Radius.r8)

                    HStack(spacing: Spacing.s12) {
                        EtmaenSkeletonCircle(size: 56)

                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            EtmaenSkeletonRect(width: 140, height: 16, radius: Radius.r8)
                            EtmaenSkeletonRect(width: 180, height: 12, radius: Radius.r8)
                        }

                        Spacer()
                    }
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)
            }
            .padding(Spacing.s16)
            .padding(.bottom, Spacing.s32)
        }
    }
 
    private func statusHeader(_ detail: VisitDetail) -> some View {
        VStack(spacing: Spacing.s16) {
            ZStack {
                Circle()
                    .fill(Color.mintSurface)
                    .frame(width: 96, height: 96)
 
                Image(systemName: "cross.case.fill")
                    .carelyText(style: .heading1)
                    .foregroundColor(.brandPrimary)
            }
 
            Text(detail.serviceName)
                .carelyText(style: .heading2, weight: .bold)
                .foregroundColor(.primaryFont)
 
            VisitStatusBadge(status: detail.status)
        }
        .padding(.top, Spacing.s16)
    }
 
    private func visitDetailsCard(_ detail: VisitDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s20) {
            Text("VISIT DETAILS")
                .carelyText(style: .caption, weight: .bold)
                .foregroundColor(.brandPrimary)
 
            VisitDetailRow(iconName: "bag.fill", label: "Service", value: detail.serviceName)
            VisitDetailRow(iconName: "clock", label: "Date", value: detail.dateText)
            VisitDetailRow(iconName: "clock", label: "Time", value: detail.timeText)
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
 
    private func careProviderCard(_ detail: VisitDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            Text("CARE PROVIDER")
                .carelyText(style: .caption, weight: .bold)
                .foregroundColor(.brandPrimary)
 
            HStack(spacing: Spacing.s12) {
                nurseAvatar(detail.nurseImageUrl)
 
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(detail.nurseName)
                        .carelyText(style: .bodyRegular, weight: .bold)
                        .foregroundColor(.primaryFont)
 
                    Text(detail.nurseTitle)
                        .carelyText(style: .bodySmall)
                        .foregroundColor(.secondaryFont)
                }
 
                Spacer()
            }
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
 
    private func descriptionCard(_ description: String) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("DESCRIPTION")
                .carelyText(style: .caption, weight: .bold)
                .foregroundColor(.brandPrimary)
 
            Text(description)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.primaryFont)
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
 
    private func nurseAvatar(_ urlString: String?) -> some View {
        Group {
            if let urlString, let url = URL(string: urlString) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure:
                        Image(systemName: "person.fill").foregroundColor(.brandPrimary)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "person.fill")
                    .foregroundColor(.brandPrimary)
            }
        }
        .frame(width: 56, height: 56)
        .background(Color.primaryContainer.opacity(0.3))
        .clipShape(Circle())
    }
}
