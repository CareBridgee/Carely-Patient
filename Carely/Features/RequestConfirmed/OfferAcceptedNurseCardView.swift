import SwiftUI

struct OfferAcceptedNurseCardView: View {
    let nurse: ConfirmedOffer.NurseDetails
    let estimatedArrival: String
    var onCallTapped: () -> Void
    var onMessageTapped: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.s16) {
            HStack(alignment: .top, spacing: Spacing.s12) {
                // Profile Image Placeholder
                RoundedRectangle(cornerRadius: Radius.r12)
                    .fill(Color.primaryVariant.opacity(0.15))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "person.crop.circle")
                            .foregroundColor(Color.primaryVariant)
                    )
                
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text(nurse.fullName)
                        .carelyText(style: .heading3, weight: .semiBold)
                        .foregroundColor(Color.primaryFont)
                    
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "checkmark.seal")
                            .foregroundColor(Color.brandPrimary)
                            .font(.system(size: 14))
                        Text("\(nurse.reviewsCount) Reviews")
                            .carelyText(style: .bodySmall, weight: .medium)
                            .foregroundColor(Color.brandPrimary)
                    }
                }
                
                Spacer()
                
                // Rating Pill
                HStack(spacing: Spacing.s4) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 12))
                    Text(String(format: "%.1f", nurse.rating))
                        .carelyText(style: .bodySmall, weight: .medium)
                }
                .foregroundColor(Color.secondaryFont)
                .padding(.horizontal, Spacing.s8)
                .padding(.vertical, Spacing.s4)
                .background(Color.mintSurface)
                .cornerRadius(Radius.r16)
            }
            
            Divider()
                .background(Color.divider)
            
            HStack {
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    Text("Estimated Arrival")
                        .carelyText(style: .caption)
                        .foregroundColor(Color.secondaryFont)
                    Text(estimatedArrival)
                        .carelyText(style: .heading3, weight: .bold)
                        .foregroundColor(Color.brandPrimary)
                }
                
                Spacer()
                
                HStack(spacing: Spacing.s12) {
                    Button(action: onCallTapped) {
                        Image(systemName: "phone")
                            .font(.system(size: 20))
                            .foregroundColor(Color.brandPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.surfaceVariant)
                            .cornerRadius(Radius.r12)
                    }
                    
                    Button(action: onMessageTapped) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 20))
                            .foregroundColor(Color.brandPrimary)
                            .frame(width: 44, height: 44)
                            .background(Color.surfaceVariant)
                            .cornerRadius(Radius.r12)
                    }
                }
            }
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .cornerRadius(Radius.r24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
