//
//  AllServiceView.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI

struct AllServiceView: View {
    @StateObject var viewModel: AllServiceViewModel
    var coordinator: ServicesCoordinator?
    
    private let columns = [
        GridItem(.flexible(), spacing: Spacing.s12),
        GridItem(.flexible(), spacing: Spacing.s12)
    ]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s16) {
                HomeTopBar(
                        greetingName: viewModel.greetingName,
                        profileImageUrl: viewModel.profileImageUrl
                    ) {}
                    .padding(.horizontal)
                SearchField(
                    placeholder: "Search for services...",
                    text: $viewModel.searchQuery
                )
                .padding(.horizontal)
                
                if viewModel.isLoading && viewModel.categories.isEmpty {
                    EtmaenServiceGridSkeleton()
                        .padding(.horizontal)
                } else if viewModel.categories.isEmpty {
                    ContentUnavailableView(
                        "No Services Found",
                        systemImage: "magnifyingglass",
                        description: Text("Try searching for another service.")
                    )
                    .padding(.top, Spacing.s40)
                } else {
                    LazyVGrid(columns: columns, spacing: Spacing.s12) {
                        ForEach(viewModel.categories) { category in
                            ServiceCategoryCard(category: category) {
                                viewModel.categoryTapped(category)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                HelpBannerView()
                    .padding(.horizontal)
                    .padding(.top, Spacing.s8)
                    .padding(.bottom, Spacing.s64)
            }
            .padding(.vertical)
        }
        .background(Color.backGround.ignoresSafeArea())
        .task {
            viewModel.loadCategories()
        }
    }
}

//#Preview {
//    AllServiceView(viewModel: AllServiceViewModel(
//        getGreetingNameUseCase: GetGreetingNameUseCase(repository: HomeRepositoryImpl()), getServiceCategoriesUseCase: GetServiceCategoriesUseCase(repository: HomeRepositoryImpl()),
//        searchServiceCategoriesUseCase: SearchServiceCategoriesUseCase(repository: HomeRepositoryImpl()),
//        coordinator: ServicesCoordinator()
//    ))
//}
