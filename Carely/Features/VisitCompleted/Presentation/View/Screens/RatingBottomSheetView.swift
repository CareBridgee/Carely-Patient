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
    }
 
    private var illustration: some View {
        ZStack(alignment: .bottomTrailing) {
            Circle()
                .fill(Color.purple.opacity(0.12))
                .frame(width: 96, height: 96)
                .overlay(
                    Image(systemName: "photo.fill")
                        .carelyText(style: .heading2)
                        .foregroundColor(.purple.opacity(0.55))
                )
 
            Image(systemName: "checkmark.seal.fill")
                .carelyText(style: .heading3)
                .foregroundColor(.onSuccessContainer)
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
 
#Preview {
    RatingBottomSheetView(selectedStars: .constant(3), isSubmitting: false)
        .background(Color.surface)
}
 
