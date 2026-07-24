import SwiftUI

struct OfferAcceptedInfoCardView: View {
    let iconName: String
    let title: String
    let subtitle: String
    let isPrimaryStyle: Bool
    
    var body: some View {
        VStack(spacing: Spacing.s12) {
            Circle()
                .fill(isPrimaryStyle ? Color.brandPrimary : Color.mintSurface)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: iconName)
                        .foregroundColor(isPrimaryStyle ? Color.surface : Color.brandPrimary)
                        .font(.system(size: 20))
                )
            
            VStack(spacing: Spacing.s4) {
                Text(title)
                    .carelyText(style: .caption)
                    .foregroundColor(Color.secondaryFont)
                
                Text(subtitle)
                    .carelyText(style: .bodyRegular, weight: .semiBold)
                    .foregroundColor(Color.primaryFont)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Spacing.s20)
        .background(Color.surface)
        .cornerRadius(Radius.r24)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
    }
}
