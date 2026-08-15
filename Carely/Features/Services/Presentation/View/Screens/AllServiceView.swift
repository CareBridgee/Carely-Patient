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
    
    private var leftColumnCategories: [ServiceCategory] {
        viewModel.categories.enumerated().compactMap { index, category in
            index % 2 == 0 ? category : nil
        }
    }
    
    private var rightColumnCategories: [ServiceCategory] {
        viewModel.categories.enumerated().compactMap { index, category in
            index % 2 == 1 ? category : nil
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: Spacing.s16) {
                Text("Services")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundColor(.brandPrimary)
                    .padding(.horizontal)
                    .padding(.top, Spacing.s0)
                
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
                    HStack(alignment: .top, spacing: Spacing.s12) {
                        LazyVStack(spacing: Spacing.s12) {
                            ForEach(Array(leftColumnCategories.enumerated()), id: \.element.id) { index, category in
                                let isBigger = (index % 2 == 0) // Big, Small, Big, Small...
                                ServiceCategoryCard(category: category, isBigger: isBigger) {
                                    viewModel.categoryTapped(category)
                                }
                            }
                        }
                        LazyVStack(spacing: Spacing.s12) {
                            ForEach(Array(rightColumnCategories.enumerated()), id: \.element.id) { index, category in
                                let isBigger = (index % 2 == 1) // Small, Big, Small, Big...
                                ServiceCategoryCard(category: category, isBigger: isBigger) {
                                    viewModel.categoryTapped(category)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                HelpBannerView()
                    .padding(.horizontal)
                    .padding(.top, Spacing.s8)
                    .padding(.bottom, 0)
            }
            .padding(.vertical)
        }
        .background(Color.backGround.ignoresSafeArea())
        .onAppear {
            viewModel.onAppear()
        }
    }
}

#Preview {
    struct PreviewGetServiceCategoriesUseCase: GetServiceCategoriesUseCaseProtocol {
        func execute() async throws -> [ServiceCategory] {
            [
                ServiceCategory(id: "1", title: "injection", subtitle: "Professional care", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "2", title: "injection", subtitle: "", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "3", title: "\"Test\"", subtitle: "", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "4", title: "\"Test2\"", subtitle: "Professional care", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "5", title: "General Nursing", subtitle: "Professional care", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "6", title: "E2E Nursing Services", subtitle: "", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "7", title: "Adversarial 161870", subtitle: "", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil),
                ServiceCategory(id: "8", title: "Cancel Probe 157795", subtitle: "Professional care", iconName: "photo", layout: .standard, accent: .neutral, imageUrl: nil)
            ]
        }
    }
    
    struct PreviewSearchServiceCategoriesUseCase: SearchServiceCategoriesUseCaseProtocol {
        func execute(query: String) async throws -> [ServiceCategory] {
            []
        }
    }
    
    let sessionManager = SessionManager(tokenStore: KeychainTokenStore())
    let store = ServiceTypesStore()
    let viewModel = AllServiceViewModel(
        getServiceCategoriesUseCase: PreviewGetServiceCategoriesUseCase(),
        searchServiceCategoriesUseCase: PreviewSearchServiceCategoriesUseCase(),
        sessionManager: sessionManager,
        serviceTypesStore: store,
        coordinator: ServicesCoordinator()
    )
    
    return AllServiceView(viewModel: viewModel)
}
