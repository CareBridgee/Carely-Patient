import SwiftUI

struct ConditionCardView: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Spacing.s8) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: IconSize.s24, height: IconSize.s24)
                    .foregroundColor(isSelected ? .brandPrimary : .primaryFont)
                
                Text(title)
                    .carelyText(style: .bodySmall, weight: .regular)
                    .foregroundColor(.primaryFont)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(Spacing.s16)
            .background(isSelected ? Color.mintSurface : Color.white)
            .cornerRadius(Radius.r12)
            .overlay(
                RoundedRectangle.carely(Radius.r12)
                    .stroke(Color.brandPrimary, lineWidth: 0.3)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
