//
//  VisitCompletedViewModel.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import Foundation
 
/// Delay before the "How was your visit?" rating sheet is presented
/// automatically, giving the person a moment to read the summary first.
private let ratingSheetAutoPresentDelayNanoseconds: UInt64 = 5_000_000_000
 
@MainActor
final class VisitCompletedViewModel: ObservableObject {
 
    let visitId: String
 
    @Published private(set) var summary: VisitSummary?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
 
    @Published var showRatingSheet: Bool = false
    @Published var selectedStars: Int = 0
    @Published var isSubmittingRating: Bool = false
    @Published var ratingSubmitted: Bool = false
 
    private let getVisitSummaryUseCase: GetVisitSummaryUseCaseProtocol
    private let submitVisitRatingUseCase: SubmitVisitRatingUseCaseProtocol
    private var autoPresentTask: Task<Void, Never>?
 
    init(
        visitId: String,
        getVisitSummaryUseCase: GetVisitSummaryUseCaseProtocol,
        submitVisitRatingUseCase: SubmitVisitRatingUseCaseProtocol
    ) {
        self.visitId = visitId
        self.getVisitSummaryUseCase = getVisitSummaryUseCase
        self.submitVisitRatingUseCase = submitVisitRatingUseCase
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
                self.errorMessage = error.localizedDescription
                self.showError = true
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
 
    func starTapped(_ star: Int) {
        selectedStars = star
    }
 
    func submitRatingTapped() {
        guard selectedStars > 0 else { return }
        isSubmittingRating = true
 
        Task {
            do {
                try await submitVisitRatingUseCase.execute(VisitRating(visitId: visitId, stars: selectedStars))
                self.isSubmittingRating = false
                self.ratingSubmitted = true
                self.showRatingSheet = false
            } catch {
                self.isSubmittingRating = false
                self.errorMessage = error.localizedDescription
                self.showError = true
            }
        }
    }
 
    func dismissRatingSheet() {
        showRatingSheet = false
    }
}
 
