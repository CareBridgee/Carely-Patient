//
//  ServiceCategoriesView.swift
//  Carely
//
//  Created by Mina on 22/07/2026.
//

import SwiftUI
 
struct ServiceCategoriesView: View {
    @StateObject private var viewModel: ServiceCategoriesViewModel
 
    init(viewModel: ServiceCategoriesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
 
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
 
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: Spacing.s24) {
                        header
 
                        SearchField(
                            placeholder: "Search services (e.g. Injection)",
                            text: $viewModel.searchQuery
                        )
 
                        sectionTitle
 
                        bentoGrid
 
                        HelpBannerView()
                    }
                    .padding(Spacing.s16)
                    .padding(.bottom, Spacing.s24)
                }
 
                HomeBottomNavBar(
                    selectedTab: .services,
                    onHomeTapped: viewModel.backTapped
                )
            }
 
            if viewModel.isLoading && viewModel.categories.isEmpty {
                ProgressView()
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .alert("Something went wrong", isPresented: $viewModel.showError) {
            Button("Retry") { viewModel.loadCategories() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "Please try again.")
        }
    }
 
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("Service Categories")
                    .carelyText(style: .heading2, weight: .semiBold)
                    .foregroundColor(.primaryFont)
                Text("Expert care delivered to your doorstep")
                    .carelyText(style: .caption)
                    .foregroundColor(.secondaryFont)
            }
            Spacer()
        }
    }
 
    private var sectionTitle: some View {
        HStack {
            Spacer()
            Button("View All") {}
                .carelyText(style: .bodySmall, weight: .semiBold)
                .foregroundColor(.brandPrimary)
        }
    }
 
    /// Groups the flat categories list into bento rows: a tall
    /// `.featured` card pairs with the next two `.standard` cards to its
    /// right, `.wide` cards span the full row, and remaining `.standard`
    /// cards are laid out two-per-row (a lone trailing item spans full
    /// width to avoid an empty grid gap).
    private var bentoGrid: some View {
        VStack(spacing: Spacing.s12) {
            ForEach(Array(bentoRows.enumerated()), id: \.offset) { _, row in
                switch row {
                case .featuredWithPair(let featured, let first, let second):
                    HStack(spacing: Spacing.s12) {
                        ServiceCategoryBentoCard(category: featured) {
                            viewModel.categoryTapped(featured)
                        }
                        .frame(height: 280)
 
                        VStack(spacing: Spacing.s12) {
                            ServiceCategoryBentoCard(category: first) {
                                viewModel.categoryTapped(first)
                            }
                            ServiceCategoryBentoCard(category: second) {
                                viewModel.categoryTapped(second)
                            }
                        }
                        .frame(height: 280)
                    }
 
                case .pair(let first, let second):
                    HStack(spacing: Spacing.s12) {
                        ServiceCategoryBentoCard(category: first) {
                            viewModel.categoryTapped(first)
                        }
                        ServiceCategoryBentoCard(category: second) {
                            viewModel.categoryTapped(second)
                        }
                    }
                    .frame(height: 132)
 
                case .single(let category):
                    ServiceCategoryBentoCard(category: category) {
                        viewModel.categoryTapped(category)
                    }
                    .frame(height: category.layout == .wide ? 96 : 132)
                }
            }
        }
    }
 
    private var bentoRows: [BentoRow] {
        Self.makeRows(from: viewModel.categories)
    }
 
    private enum BentoRow {
        case featuredWithPair(ServiceCategory, ServiceCategory, ServiceCategory)
        case pair(ServiceCategory, ServiceCategory)
        case single(ServiceCategory)
    }
 
    private static func makeRows(from categories: [ServiceCategory]) -> [BentoRow] {
        var rows: [BentoRow] = []
        var buffer: [ServiceCategory] = []
        var index = 0
 
        func flushBuffer() {
            if buffer.count == 2 {
                rows.append(.pair(buffer[0], buffer[1]))
            } else if let single = buffer.first {
                rows.append(.single(single))
            }
            buffer.removeAll()
        }
 
        while index < categories.count {
            let category = categories[index]
 
            switch category.layout {
            case .featured:
                flushBuffer()
                let next = categories[(index + 1)...].prefix(2).filter { $0.layout == .standard }
                if next.count == 2 {
                    rows.append(.featuredWithPair(category, next[next.startIndex], next[next.startIndex + 1]))
                    index += 1 + next.count
                } else {
                    rows.append(.single(category))
                    index += 1
                }
 
            case .wide:
                flushBuffer()
                rows.append(.single(category))
                index += 1
 
            case .standard:
                buffer.append(category)
                if buffer.count == 2 {
                    flushBuffer()
                }
                index += 1
            }
        }
        flushBuffer()
 
        return rows
    }
}

//#Preview {
//    let repository = HomeRepositoryImpl()
//    ServiceCategoriesView(
//        viewModel: ServiceCategoriesViewModel(
//            getServiceCategoriesUseCase: GetServiceCategoriesUseCase(repository: repository),
//            searchServiceCategoriesUseCase: SearchServiceCategoriesUseCase(repository: repository),
//            router: HomeRouter()
//        )
//    )
//}
