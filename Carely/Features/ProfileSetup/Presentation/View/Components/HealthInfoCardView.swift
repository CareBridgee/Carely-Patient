import SwiftUI

struct HealthInfoCardView: View {
    var body: some View {
        HStack(alignment: .top, spacing: Spacing.s16) {
            RoundedRectangle.carely(Radius.r12)
                .fill(Color.primaryContainer)
                .frame(width: 48, height: 48)
                .overlay(
                    Image(systemName: "cross.case.fill")
                        .foregroundColor(.brandPrimary)
                        .font(.system(size: 20))
                )
            
            VStack(alignment: .leading, spacing: Spacing.s4) {
                Text("Basic Health Info")
                    .carelyText(style: .bodyLarge, weight: .medium)
                    .foregroundColor(.primaryFont)
                
                Text("Providing these details helps our specialists prepare a personalized care plan tailored to your physical requirements.")
                    .carelyText(style: .bodySmall, weight: .light)
                    .foregroundColor(.secondaryFont)
                    .lineSpacing(4)
            }
        }
        .padding(Spacing.s16)
        .background(Color.white)
        .cornerRadius(Radius.r16)
        .carelyShadow(.sm)
    }
}
