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
            
            if let loadError = viewModel.loadError, viewModel.previewCategories.isEmpty {
                ErrorStateView(error: loadError) {
                    viewModel.retryInitialLoad()
                }
            } else if viewModel.isLoading && viewModel.previewCategories.isEmpty {
                homeSkeletonView
            } else {
                VStack(spacing: 0) {
                    HomeTopBar(
                        greetingName: viewModel.greetingName,
                        profileImageUrl: viewModel.profileImageUrl,
                        onProfileTapped: viewModel.profileTapped
                    )
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s8)
                    .padding(.bottom, Spacing.s12)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: Spacing.s20) {
                            SearchField(
                                placeholder: "Search services, symptoms...",
                                text: $searchText
                            )
                            
                            AIAssessmentBannerView {
                                viewModel.aiBannerTapped()
                            }
                            
                            servicesSection
                            
                            if !viewModel.upcomingBookings.isEmpty {
                                bookingsSection
                            }
                        }
                        .padding(.horizontal, Spacing.s16)
                        .padding(.top, Spacing.s8)
                        .padding(.bottom, viewModel.hasActiveVisit ? 80 : Spacing.s24)
                    }
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
        .errorToast($viewModel.errorMessage)
    }
    
    private var homeSkeletonView: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: Spacing.s8) {
                    EtmaenSkeletonRect(width: 120, height: 14, radius: Radius.r8)
                    EtmaenSkeletonRect(width: 180, height: 22, radius: Radius.r8)
                }
                Spacer()
                EtmaenSkeletonCircle(size: 44)
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.top, Spacing.s8)
            .padding(.bottom, Spacing.s12)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: Spacing.s20) {
                    EtmaenSkeletonRect(height: 48, radius: Radius.r16)
                    
                    EtmaenSkeletonRect(height: 110, radius: Radius.r20)
                    
                    VStack(alignment: .leading, spacing: Spacing.s12) {
                        EtmaenSkeletonRect(width: 140, height: 18, radius: Radius.r8)
                        EtmaenServiceGridSkeleton()
                    }
                }
                .padding(.horizontal, Spacing.s16)
                .padding(.top, Spacing.s8)
                .padding(.bottom, Spacing.s64)
            }
        }
    }
    
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            HStack {
                Text("Healthcare Services")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(.primaryFont)
            }
            
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Spacing.s12), GridItem(.flexible(), spacing: Spacing.s12)],
                spacing: Spacing.s12
            ) {
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
                    isHighlighted: true,
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
