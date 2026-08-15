//
//  HomeView.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var searchText: String = ""

    init(viewModel: HomeViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()

            VStack {
                if viewModel.isLoading && viewModel.previewCategories.isEmpty {
                    homeSkeletonView
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: Spacing.s20) {
                            HomeTopBar(
                                greetingName: viewModel.greetingName,
                                profileImageUrl: viewModel.profileImageUrl
                            ) {}

                            SearchField(
                                placeholder: "Search services, symptoms...",
                                text: $searchText
                            )

                            AIAssessmentBannerView {}

                            servicesSection

                            if !viewModel.upcomingBookings.isEmpty {
                                bookingsSection
                            }
                        }
                      //  .padding(Spacing.s16)
                     //   .padding(.bottom, Spacing.s64)
                    }
                    .padding(Spacing.s16)
                    .padding(.bottom, viewModel.hasActiveVisit ? 50 : 0)
                }
            }

            if viewModel.hasActiveVisit {
                VStack {
                    Spacer()
                    ActiveVisitFloatingBannerView {
                        viewModel.activeVisitBannerTapped()
                    }
                    .padding(.horizontal, Spacing.s16)
                    .padding(.bottom, 22)
                }
            }
        }
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadDashboard() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }

    private var homeSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s20) {
                HStack {
                    VStack(alignment: .leading, spacing: Spacing.s8) {
                        EtmaenSkeletonRect(width: 120, height: 14, radius: Radius.r8)
                        EtmaenSkeletonRect(width: 180, height: 22, radius: Radius.r8)
                    }
                    Spacer()
                    EtmaenSkeletonCircle(size: 44)
                }

                EtmaenSkeletonRect(height: 48, radius: Radius.r16)

                EtmaenSkeletonRect(height: 110, radius: Radius.r20)

                VStack(alignment: .leading, spacing: Spacing.s12) {
                    EtmaenSkeletonRect(width: 140, height: 18, radius: Radius.r8)
                    EtmaenServiceGridSkeleton()
                }
            }
            .padding(Spacing.s16)
            .padding(.bottom, Spacing.s64)
        }
    }

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            HStack {
                Text("Healthcare Services")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(.primaryFont)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.s12) {
                ForEach(viewModel.previewCategories) { category in
                    ServiceCategoryTile(
                        title: category.title,
                        iconName: category.iconName,
                        imageUrl: category.imageUrl,
                        action: { viewModel.categoryTapped(category) }
                    )
                }
                
                ServiceCategoryTile(
                    title: "More Services",
                    iconName: "ellipsis",
                    action: viewModel.viewAllServicesTapped
                )
            }
        }
    }

    private var bookingsSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            HStack {
                Text("History")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(.primaryFont)

                Spacer()

                Button("See All") { viewModel.seeAllHistoryTapped() }
                    .carelyText(style: .bodySmall, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
            }

            ForEach(viewModel.upcomingBookings) { booking in
                UpcomingBookingCard(booking: booking)
            }
        }
    }
}

//#Preview {
//    let repository = HomeRepositoryImpl()
//    HomeView(
//        viewModel: HomeViewModel(
//            getGreetingNameUseCase: GetGreetingNameUseCase(repository: repository),
//            getServiceCategoriesUseCase: GetServiceCategoriesUseCase(repository: repository),
//            getUpcomingBookingsUseCase: GetUpcomingBookingsUseCase(repository: repository),
//            onServiceTabbed: {}
//        )
//    )
//}
