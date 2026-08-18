//
//  VisitCompletedViewModel.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation

private let ratingSheetAutoPresentDelayNanoseconds: UInt64 = 1_000_000_000
private let closeAfterRatingDelayNanoseconds: UInt64 = 1_200_000_000

@MainActor
final class VisitCompletedViewModel: ObservableObject {
 
    let visitId: String
 
    @Published private(set) var summary: VisitSummary?
    @Published var isLoading: Bool = false

    /// Drives the `.errorToast` for summary-load and rating-submission
    /// failures. Always the exact server message (via `error.carelyDescription`)
    /// rather than a hardcoded fallback string.
    @Published var errorMessage: String? = nil
 
    @Published var showRatingSheet: Bool = false
    @Published var selectedStars: Int = 0
    @Published var isSubmittingRating: Bool = false
    @Published var ratingSubmitted: Bool = false
 
    private let getVisitSummaryUseCase: GetVisitSummaryUseCaseProtocol
    private let submitVisitRatingUseCase: SubmitVisitRatingUseCaseProtocol
    private let onFinished: () -> Void
    private var autoPresentTask: Task<Void, Never>?
 
    init(
        visitId: String,
        getVisitSummaryUseCase: GetVisitSummaryUseCaseProtocol,
        submitVisitRatingUseCase: SubmitVisitRatingUseCaseProtocol,
        onFinished: @escaping () -> Void = {}
    ) {
        self.visitId = visitId
        self.getVisitSummaryUseCase = getVisitSummaryUseCase
        self.submitVisitRatingUseCase = submitVisitRatingUseCase
        self.onFinished = onFinished
    }
 
    func onAppear() {
        if summary == nil {
            loadSummary()
        }
        scheduleRatingSheetAutoPresent()
    }
 
    func onDisappear() {
        autoPresentTask?.cancel()
    }
 
    func loadSummary() {
        isLoading = true
        errorMessage = nil
 
        Task {
            do {
                let fetched = try await getVisitSummaryUseCase.execute(visitId: visitId)
                self.summary = fetched
                self.isLoading = false
            } catch {
                self.isLoading = false
                self.errorMessage = error.carelyDescription
            }
        }
    }
 
    /// Waits 5 seconds, then shows the rating bottom sheet — unless the
    /// person has already dismissed the screen or the sheet is already up.
    private func scheduleRatingSheetAutoPresent() {
        guard autoPresentTask == nil else { return }
        autoPresentTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: ratingSheetAutoPresentDelayNanoseconds)
            guard let self, !Task.isCancelled else { return }
            self.showRatingSheet = true
        }
    }
 
    // MARK: - Rating
 
    @Published var reviewText: String = ""
    @Published var isAnonymous: Bool = false

    func starTapped(_ star: Int) {
        selectedStars = star
    }
 
    func submitRatingTapped() {
        guard selectedStars > 0 else { return }
        isSubmittingRating = true
 
        Task {
            do {
                let rating = VisitRating(
                    visitId: visitId,
                    stars: selectedStars,
                    reviewText: reviewText,
                    isAnonymous: isAnonymous
                )
                try await submitVisitRatingUseCase.execute(rating)
                self.isSubmittingRating = false
                self.ratingSubmitted = true
                self.showRatingSheet = false
            } catch {
                self.isSubmittingRating = false
                self.errorMessage = error.carelyDescription
            }
        }
    }
 
    func dismissRatingSheet() {
        showRatingSheet = false
    }

    func returnHome() {
        autoPresentTask?.cancel()
        onFinished()
    }
}
