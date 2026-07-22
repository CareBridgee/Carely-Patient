//
//  ServiceDetailsView.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct ServiceDetailsView: View {
    @StateObject private var viewModel: ServiceDetailsViewModel
 
    init(viewModel: ServiceDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
 
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
 
            if let detail = viewModel.detail {
                VStack(spacing: 0) {
                    ScrollView {
                        VStack(alignment: .leading, spacing: Spacing.s24) {
                            heroSection(detail)
                            infoHeader(detail)
                            priceDurationSection(detail)
                            aboutSection(detail)
                            includedSection(detail)
                            noteSection(detail)
                        }
                        .padding(Spacing.s16)
                        .padding(.bottom, 96)
                    }
                }
 
                VStack {
                    Spacer()
                    bookButton
                        .padding(Spacing.s16)
                        .background(Color.backGround.opacity(0.9))
                }
            } else if viewModel.isLoading {
                ProgressView()
            }
 
            VStack {
                topBar
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadDetail() }
            Button("Back", role: .cancel) { viewModel.backTapped() }
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
        .alert("Booking Confirmed", isPresented: $viewModel.bookingConfirmed) {
            Button("OK") {}
        } message: {
            Text("Your service has been booked. We'll send you a confirmation shortly.")
        }
        
        Spacer(minLength: Spacing.s56)
    }
 
    // MARK: - Sections
 
    private var topBar: some View {
        HStack {
            Button(action: viewModel.backTapped) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.brandPrimary)
                    .frame(width: 40, height: 40)
                    .background(Color.surface)
                    .clipShape(RoundedRectangle.carely(Radius.r12))
            }
 
            Spacer()
 
            Text("Service Details")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
 
            Spacer()
 
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(.secondaryFont)
                .frame(width: 40, height: 40)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r12))
        }
        .padding(Spacing.s16)
    }
 
    private func heroSection(_ detail: ServiceDetail) -> some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.primaryContainer.opacity(0.25), Color.tint.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 220)
 
            Image(systemName: detail.heroIconName)
                .font(.system(size: 64))
                .foregroundColor(.onPrimary.opacity(0.4))
                .frame(maxWidth: .infinity, maxHeight: 220)
 
            HStack(spacing: Spacing.s8) {
                Image(systemName: "cross.case.fill")
                Text(detail.badgeText)
                    .carelyText(style: .bodySmall, weight: .semiBold)
            }
            .foregroundColor(.onPrimary)
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s8)
            .background(Color.brandPrimary)
            .clipShape(RoundedRectangle.carely(Radius.r16))
            .padding(Spacing.s16)
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle.carely(Radius.r32))
        .carelyShadow(.sm)
        .padding(.top, Spacing.s56)
    }
 
    private func infoHeader(_ detail: ServiceDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s4) {
            Text(detail.title)
                .carelyText(style: .heading1, weight: .bold)
                .foregroundColor(.brandPrimary)
            Text(detail.subtitle)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.secondaryFont)
        }
    }
 
    private func priceDurationSection(_ detail: ServiceDetail) -> some View {
        HStack(spacing: Spacing.s12) {
            PriceDurationCard(iconName: "creditcard.fill", label: "Starting from", value: detail.priceText)
            PriceDurationCard(iconName: "clock.fill", label: "Duration", value: detail.durationText, tintColor: .tint)
        }
    }
 
    private func aboutSection(_ detail: ServiceDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("About this service")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
            Text(detail.aboutDescription)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.secondaryFont)
                .lineSpacing(4)
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
 
    private func includedSection(_ detail: ServiceDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            Text("What's included")
                .carelyText(style: .heading3, weight: .semiBold)
                .foregroundColor(.brandPrimary)
 
            VStack(alignment: .leading, spacing: Spacing.s12) {
                ForEach(detail.includedItems, id: \.self) { item in
                    IncludedItemRow(text: item)
                }
            }
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r24))
        .carelyShadow(.sm)
    }
 
    private func noteSection(_ detail: ServiceDetail) -> some View {
        InfoBannerView(text: detail.noteText, iconName: "info.circle.fill")
    }
 
    private var bookButton: some View {
        PrimaryButton(
            title: viewModel.isBooking ? "Booking..." : "Book This Service",
            size: .large,
            icon: "arrow.right",
            iconPosition: .trailing,
            isLoading: viewModel.isBooking,
            action: viewModel.bookServiceTapped
        )
    }
}

//#Preview {
//    ServiceDetailsView(
//        viewModel: ServiceDetailsViewModel(
//            serviceId: "iv-drip",
//            getServiceDetailUseCase: GetServiceDetailUseCase(repository: HomeRepositoryImpl()),
//            router: HomeRouter()
//        )
//    )
//}
