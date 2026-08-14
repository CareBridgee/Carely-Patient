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
                topBar
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s8)
 
                content
            }
        }
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadDetail() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
 
    private var topBar: some View {
        HStack {
            Button(action: onBackTapped) {
                Image(systemName: "arrow.left")
                    .carelyText(style: .bodyLarge, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(Circle())
            }
 
            Spacer()
 
            Text("Visit Details")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
 
            Spacer()
 
            Color.clear.frame(width: 40, height: 40)
        }
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
            Spacer()
            ProgressView()
            Spacer()
        } else {
            Spacer()
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
 
