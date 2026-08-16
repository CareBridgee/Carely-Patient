//
//  VisitCompletedView.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct VisitCompletedView: View {
    @StateObject private var viewModel: VisitCompletedViewModel
 
    init(viewModel: VisitCompletedViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
 
    var body: some View {
        ZStack {
            Color.backGround.ignoresSafeArea()
 
            VStack(spacing: 0) {
                VisitSummaryTopBar()
                    .padding(.horizontal, Spacing.s16)
                    .padding(.top, Spacing.s8)
 
                if let summary = viewModel.summary {
                    ScrollView {
                        VStack(spacing: Spacing.s24) {
                            statusHeader
                            SummaryDetailCard(summary: summary)
                            TotalAmountDueCard(amountText: summary.totalAmountText)
                        }
                        .padding(Spacing.s16)
                        .padding(.bottom, Spacing.s16)
                    }

                    // Return Home Button
                    PrimaryButton(
                        title: "Return Home",
                        size: .medium,
                        radius: Radius.r16
                    ) {
                        viewModel.returnHome()
                    }
                    .padding(.horizontal, Spacing.s20)
                    .padding(.top, Spacing.s8)
                    .padding(.bottom, Spacing.s24)
                    .background(Color.backGround.ignoresSafeArea(edges: .bottom))
                } else if viewModel.isLoading {
                    visitCompletedSkeletonView
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear { viewModel.onAppear() }
        .onDisappear { viewModel.onDisappear() }
        .errorToast($viewModel.errorMessage)
        .sheet(isPresented: $viewModel.showRatingSheet) {
            RatingBottomSheetView(
                selectedStars: $viewModel.selectedStars,
                reviewText: $viewModel.reviewText,
                isAnonymous: $viewModel.isAnonymous,
                isSubmitting: viewModel.isSubmittingRating,
                onStarTapped: viewModel.starTapped,
                onSubmit: viewModel.submitRatingTapped,
                errorMessage: $viewModel.errorMessage
                onSkip: viewModel.dismissRatingSheet
            )
            .presentationDetents([.height(490)])
            .presentationDragIndicator(.visible)
            .presentationCornerRadius(Radius.r24)
        }
    }
 
    private var statusHeader: some View {
        VStack(spacing: Spacing.s16) {
            ZStack {
                Circle()
                    .fill(Color.mintSurface)
                    .frame(width: 96, height: 96)
 
                Image(systemName: "checkmark")
                    .carelyText(style: .heading1,weight: .bold)
                    .foregroundColor(.onPrimary)
                    .frame(width: 64, height: 64)
                    .background(Color.brandPrimary)
                    .clipShape(Circle())
            }
            .padding(.top, Spacing.s24)
 
            VStack(spacing: Spacing.s8) {
                Text("Visit Completed")
                    .carelyText(style: .heading2, weight: .bold)
                    .foregroundColor(.primaryFont)
 
                Text("Your medical professional has finalized the session report. Thank you for choosing Carely.")
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(.secondaryFont)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var visitCompletedSkeletonView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: Spacing.s24) {
                // Status Header Skeleton
                VStack(spacing: Spacing.s16) {
                    EtmaenSkeletonCircle(size: 96)
                    EtmaenSkeletonRect(width: 180, height: 24, radius: Radius.r8)
                    EtmaenSkeletonRect(width: 260, height: 16, radius: Radius.r8)
                }
                .padding(.top, Spacing.s24)

                // Summary Detail Card Skeleton
                VStack(alignment: .leading, spacing: Spacing.s16) {
                    HStack {
                        EtmaenSkeletonRect(width: 130, height: 14, radius: Radius.r8)
                        Spacer()
                        EtmaenSkeletonRect(width: 90, height: 22, radius: Radius.r12)
                    }

                    Divider()

                    HStack(alignment: .top, spacing: Spacing.s16) {
                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            EtmaenSkeletonRect(width: 90, height: 12, radius: Radius.r8)
                            EtmaenSkeletonRect(width: 110, height: 16, radius: Radius.r8)
                        }
                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            EtmaenSkeletonRect(width: 80, height: 12, radius: Radius.r8)
                            EtmaenSkeletonRect(width: 100, height: 16, radius: Radius.r8)
                        }
                    }

                    HStack(alignment: .top, spacing: Spacing.s16) {
                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            EtmaenSkeletonRect(width: 80, height: 12, radius: Radius.r8)
                            EtmaenSkeletonRect(width: 90, height: 16, radius: Radius.r8)
                        }
                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            EtmaenSkeletonRect(width: 90, height: 12, radius: Radius.r8)
                            EtmaenSkeletonRect(width: 90, height: 16, radius: Radius.r8)
                        }
                    }
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)

                // Total Amount Due Card Skeleton
                HStack {
                    EtmaenSkeletonRect(width: 140, height: 14, radius: Radius.r8)
                    Spacer()
                    EtmaenSkeletonRect(width: 80, height: 18, radius: Radius.r8)
                }
                .padding(Spacing.s20)
                .frame(maxWidth: .infinity)
                .background(Color.surface)
                .clipShape(RoundedRectangle.carely(Radius.r24))
                .carelyShadow(.sm)
            }
            .padding(Spacing.s16)
            .padding(.bottom, Spacing.s24)
        }
    }
}
 
//#Preview {
//    let repository = VisitSummaryRepositoryImpl()
//    VisitCompletedView(
//        viewModel: VisitCompletedViewModel(
//            visitId: "visit-1",
//            getVisitSummaryUseCase: GetVisitSummaryUseCase(repository: repository),
//            submitVisitRatingUseCase: SubmitVisitRatingUseCase(repository: repository)
//        )
//    )
//}
