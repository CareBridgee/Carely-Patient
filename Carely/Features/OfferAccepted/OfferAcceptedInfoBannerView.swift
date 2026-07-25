import SwiftUI

struct OfferAcceptedInfoBannerView: View {
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: "info.circle")
                .foregroundColor(Color.brandPrimary)
                .font(.system(size: 20))
                
            Text("You can cancel within 2 minutes after the visit starts. After that, a cancellation fee will apply.")
                .carelyText(style: .bodySmall)
                .foregroundColor(Color.brandPrimary)
        }
        .padding(Spacing.s16)
        .background(Color.mintSurface)
        .cornerRadius(Radius.r16)
        .overlay(
            RoundedRectangle(cornerRadius: Radius.r16)
                .stroke(Color.brandPrimary.opacity(0.2), lineWidth: 1)
        )
    }
}
