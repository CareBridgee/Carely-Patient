//
//  RatingBottomSheetView.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct RatingBottomSheetView: View {
    @Binding var selectedStars: Int
    let isSubmitting: Bool
    var onStarTapped: (Int) -> Void = { _ in }
    var onSubmit: () -> Void = {}

    /// Drives the `.errorToast` for rating-submission failures. Bound to the
    /// same `VisitCompletedViewModel.errorMessage` the parent screen uses, so
    /// the exact server message surfaces here too — sheets present in their
    /// own hierarchy, so the parent's toast wouldn't otherwise be visible
    /// while this sheet is on screen.
    @Binding var errorMessage: String?
 
    var body: some View {
        VStack(spacing: Spacing.s20) {
            illustration
 
            VStack(spacing: Spacing.s8) {
                Text("How was your visit?")
                    .carelyText(style: .heading2, weight: .bold)
                    .foregroundColor(.primaryFont)
 
                Text("Your feedback helps us provide better care for everyone.")
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(.secondaryFont)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
 
            starRow
 
            if selectedStars > 0 {
                PrimaryButton(
                    title: isSubmitting ? "Submitting..." : "Submit Feedback",
                    isLoading: isSubmitting,
                    action: onSubmit
                )
            }
        }
        .padding(.horizontal, Spacing.s24)
        .padding(.top, Spacing.s32)
        .padding(.bottom, Spacing.s24)
        .animation(CarelyMotion.springDefault, value: selectedStars)
        .errorToast($errorMessage)
    }
 
    private var illustration: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.brandPrimary.opacity(0.12))
                .frame(width: 96, height: 96)
                .overlay(
                    Image(systemName: "photo.fill")
                        .carelyText(style: .heading2)
                        .foregroundColor(Color.brandPrimary.opacity(0.55))
                )
 
            Image(systemName: "checkmark.seal.fill")
                .carelyText(style: .heading3)
                .foregroundColor(.success)
                .background(
                    Circle()
                        .fill(Color.surface)
                        .frame(width: 26, height: 26)
                )
        }
    }
 
    private var starRow: some View {
        HStack(spacing: Spacing.s12) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    onStarTapped(star)
                } label: {
                    Image(systemName: star <= selectedStars ? "star.fill" : "star")
                        .font(.system(size: 28))
                        .foregroundColor(star <= selectedStars ? .amber : .hint)
                }
            }
        }
    }
}
 
//#Preview {
//    RatingBottomSheetView(selectedStars: .constant(3), isSubmitting: false, errorMessage: .constant(nil))
//        .background(Color.surface)
//}
//
