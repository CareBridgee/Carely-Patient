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
 
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.s24) {
                        HomeTopBar(greetingName: viewModel.greetingName){}
 
                        SearchField(
                            placeholder: "Search services, symptoms...",
                            text: $searchText
                        )
 
                        AIAssessmentBannerView(){}
 
                        servicesSection
 
                        if !viewModel.upcomingBookings.isEmpty {
                            bookingsSection
                        }
                    }
                    .padding(Spacing.s16)
                    .padding(.bottom, Spacing.s24)
                }
 
                HomeBottomNavBar(
                    selectedTab: .home,
                    onServicesTapped: viewModel.viewAllServicesTapped
                )
            }
 
            if viewModel.isLoading && viewModel.previewCategories.isEmpty {
                ProgressView()
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadDashboard() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
 
    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: Spacing.s16) {
            HStack {
                Text("Healthcare Services")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(.primaryFont)
 
                Spacer()
 
                Button("View All", action: viewModel.viewAllServicesTapped)
                    .carelyText(style: .bodySmall, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
            }
 
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.s12) {
                ForEach(viewModel.previewCategories) { category in
                    ServiceCategoryTile(
                        title: category.title,
                        iconName: category.iconName,
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
                Text("My Bookings")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(.primaryFont)
 
                Spacer()
 
                Text("Manage")
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
//            router: HomeRouter()
//        )
//    )
//}
