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
        ZStack(alignment: .top) {
            Color.backGround.ignoresSafeArea()

            if let detail = viewModel.detail {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: Spacing.s20) {
                        heroSection(detail)
                        infoHeader(detail)
                        priceDurationSection(detail)
                        aboutSection(detail)
                        includedSection(detail)
                        noteSection(detail)
                    }
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s16)
                    .padding(.bottom, Spacing.s24)
                }
                .safeAreaInset(edge: .bottom) {
                    bookButton
                        .padding(.horizontal, Spacing.s16)
                        .padding(.vertical, Spacing.s12)
                        .background(Color.backGround)
                }
            } else if viewModel.isLoading {
                serviceDetailsSkeletonView
            }
        }
        .background(Color.backGround.ignoresSafeArea())
        .careConnectNavigationBar(
            title: "Service Details",
            showBackButton: true,
            trailingIcon: "square.and.arrow.up",
            onBackTapped: {
                viewModel.backTapped()
            }
        )
        .blur(radius: (viewModel.isLoading && viewModel.detail != nil) ? 3 : 0)
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
    }

    // MARK: - Sections

    private func heroSection(_ detail: ServiceDetail) -> some View {
            ZStack(alignment: .bottomLeading) {
                
                if let imageUrlString = detail.imageUrl, let url = URL(string: imageUrlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.onProcessingContainer.opacity(0.2)
                                ProgressView()
                            }
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            fallbackPlaceholder
                        @unknown default:
                            fallbackPlaceholder
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    fallbackPlaceholder
                }

                LinearGradient(
                    colors: [Color.black.opacity(0.0), Color.black.opacity(0.6)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                HStack(spacing: Spacing.s8) {
                    Image(systemName: "cross.case.fill")
                        .font(.system(size: 12))
                    Text(detail.badgeText.isEmpty ? "Clinical Grade" : detail.badgeText)
                        .carelyText(style: .caption, weight: .semiBold)
                }
                .foregroundColor(Color.onPrimary)
                .padding(.horizontal, Spacing.s12)
                .padding(.vertical, Spacing.s8)
                .background(Color.brandPrimary)
                .clipShape(RoundedRectangle.carely(Radius.r12))
                .padding(Spacing.s16)
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle.carely(Radius.r24))
        }
        
        private var fallbackPlaceholder: some View {
            ZStack {
                RoundedRectangle(cornerRadius: Radius.r24)
                    .fill(
                        LinearGradient(
                            colors: [Color.onProcessingContainer.opacity(0.2), Color.hint.opacity(0.35)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .foregroundColor(.hint.opacity(0.6))
            }
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
            PriceDurationCard(
                iconName: "creditcard",
                label: "Average price",
                value: detail.priceText
            )
            PriceDurationCard(
                iconName: "clock",
                label: "Duration",
                value: detail.durationText
            )
        }
    }

    private func aboutSection(_ detail: ServiceDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("About this service")
                .carelyText(style: .heading3, weight: .bold)
                .foregroundColor(.brandPrimary)
            Text(detail.aboutDescription)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.secondaryFont)
                .lineSpacing(4)
        }
        .padding(Spacing.s20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surface)
        .clipShape(RoundedRectangle.carely(Radius.r20))
        .carelyShadow(.sm)
    }

    private func includedSection(_ detail: ServiceDetail) -> some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            Text("What's included")
                .carelyText(style: .heading3, weight: .bold)
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
        .clipShape(RoundedRectangle.carely(Radius.r20))
        .carelyShadow(.sm)
    }

    private func noteSection(_ detail: ServiceDetail) -> some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: "info.circle")
                .font(.system(size: 18))
                .foregroundColor(.brandPrimary)

            Text(detail.noteText.isEmpty ? "Please note: A brief health questionnaire is required before the arrival of your specialist to tailor treatment." : detail.noteText)
                .carelyText(style: .caption)
                .foregroundColor(.onBankContainer)
                .lineSpacing(2)
        }
        .padding(Spacing.s16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.brandPrimary.opacity(0.12))
        .clipShape(RoundedRectangle.carely(Radius.r16))
    }

    private var bookButton: some View {
        PrimaryButton(
            title: viewModel.isBooking ? "Booking..." : "Request This Service",
            size: .large,
            icon: "arrow.right",
            iconPosition: .trailing,
            isLoading: viewModel.isBooking,
            action: viewModel.bookServiceTapped
        )
    }

    private var serviceDetailsSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s20) {
                // Hero Section Skeleton (200pt height, Radius.r24)
                EtmaenSkeletonRect(height: 200, radius: Radius.r24)
                
                // Info Header Skeleton
                VStack(alignment: .leading, spacing: Spacing.s8) {
                    EtmaenSkeletonRect(width: 200, height: 26, radius: Radius.r8)
                    EtmaenSkeletonRect(width: 140, height: 16, radius: Radius.r8)
                }

                // Price & Duration Cards Skeleton (2 columns, Radius.r20)
                HStack(spacing: Spacing.s12) {
                    ForEach(0..<2, id: \.self) { _ in
                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            EtmaenSkeletonCircle(size: 32)
                            EtmaenSkeletonRect(width: 60, height: 12, radius: Radius.r8)
                            EtmaenSkeletonRect(width: 90, height: 16, radius: Radius.r8)
                        }
                        .padding(Spacing.s16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.surface)
                        .clipShape(RoundedRectangle.carely(Radius.r20))
                        .carelyShadow(.sm)
                    }
                }

                // About Service Card Skeleton (Radius.r20)
                VStack(alignment: .leading, spacing: Spacing.s12) {
                    EtmaenSkeletonRect(width: 150, height: 18, radius: Radius.r8)
                    EtmaenSkeletonRect(height: 14, radius: Radius.r8)
                    EtmaenSkeletonRect(height: 14, radius: Radius.r8)
                    EtmaenSkeletonRect(width: 220, height: 14, radius: Radius.r8)
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r20))
                .carelyShadow(.sm)

                // What's Included Card Skeleton (Radius.r20)
                VStack(alignment: .leading, spacing: Spacing.s16) {
                    EtmaenSkeletonRect(width: 140, height: 18, radius: Radius.r8)
                    ForEach(0..<3, id: \.self) { _ in
                        HStack(spacing: Spacing.s12) {
                            EtmaenSkeletonCircle(size: 20)
                            EtmaenSkeletonRect(width: 180, height: 14, radius: Radius.r8)
                        }
                    }
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r20))
                .carelyShadow(.sm)
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s16)
            .padding(.bottom, Spacing.s24)
        }
    }
}

//#Preview {
//    ServiceDetailsView(
//        viewModel: ServiceDetailsViewModel(serviceId: "general-nursing", getServiceDetailUseCase: GetServiceDetailUseCase(repository: HomeRepositoryImpl()), source:.services , coordinator: ServicesCoordinator())
//    )
//}
