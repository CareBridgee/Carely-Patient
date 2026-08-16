//
//  RatingBottomSheetView.swift
//  Carely
//
//  Created by Mina on 24/07/2026.
//

import SwiftUI
 
struct RatingBottomSheetView: View {
    @Binding var selectedStars: Int
    @Binding var reviewText: String
    @Binding var isAnonymous: Bool
    let isSubmitting: Bool
    var onStarTapped: (Int) -> Void = { _ in }
    var onSubmit: () -> Void = {}

    /// Drives the `.errorToast` for rating-submission failures. Bound to the
    /// same `VisitCompletedViewModel.errorMessage` the parent screen uses, so
    /// the exact server message surfaces here too — sheets present in their
    /// own hierarchy, so the parent's toast wouldn't otherwise be visible
    /// while this sheet is on screen.
    @Binding var errorMessage: String?
 
    var onSkip: () -> Void = {}

    var body: some View {
        VStack(spacing: Spacing.s20) {
            illustration

            VStack(spacing: Spacing.s8) {
                Text("How was your visit?")
                    .carelyText(style: .heading2, weight: .bold)
                    .foregroundColor(.primaryFont)

                Text("Your feedback helps us provide better\ncare for everyone.")
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(.secondaryFont)
                    .multilineTextAlignment(.center)
            }

            starRow

            // Review text editor
            TextEditor(text: $reviewText)
                .frame(height: 100)
                .padding(Spacing.s8)
                .background(Color.backGround)
                .cornerRadius(Radius.r16)
                .overlay(
                    RoundedRectangle(cornerRadius: Radius.r16)
                        .stroke(Color.brandPrimary.opacity(0.8), lineWidth: 1)
                )

            // Submit anonymously Checkbox
            HStack(spacing: Spacing.s12) {
                Button {
                    isAnonymous.toggle()
                } label: {
                    Image(systemName: isAnonymous ? "checkmark.square.fill" : "square")
                        .font(.system(size: 20))
                        .foregroundColor(isAnonymous ? .brandPrimary : .hint)
                }

                Text("Submit anonymously")
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.primaryFont)

                Spacer()
            }

            // Bottom Buttons (Skip & Submit)
            HStack(spacing: Spacing.s16) {
                Button {
                    onSkip()
                } label: {
                    Text("Skip")
                        .carelyText(style: .bodyLarge, weight: .semiBold)
                        .foregroundColor(.primaryFont)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                }

                PrimaryButton(
                    title: isSubmitting ? "Submitting..." : "Submit",
                    size: .medium,
                    radius: Radius.r16,
                    isLoading: isSubmitting,
                    isEnabled: selectedStars > 0,
                    action: onSubmit
                )
            }
            .padding(.top, Spacing.s8)
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
                .fill(Color.brandPrimary.opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "star.fill")
                        .font(.system(size: 34))
                        .foregroundColor(.brandPrimary)
                )

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.brandPrimary)
                .background(
                    Circle()
                        .fill(Color.surface)
                        .frame(width: 20, height: 20)
                )
                .offset(x: 2, y: 2)
        }
    }

    private var starRow: some View {
        HStack(spacing: Spacing.s16) {
            ForEach(1...5, id: \.self) { star in
                Button {
                    onStarTapped(star)
                } label: {
                    Image(systemName: star <= selectedStars ? "star.fill" : "star")
                        .font(.system(size: 32))
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
