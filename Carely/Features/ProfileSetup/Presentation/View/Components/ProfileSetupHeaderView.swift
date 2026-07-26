import SwiftUI

struct ProfileSetupHeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            Text(title)
                .carelyText(style: .bodyLarge, weight: .semiBold)
                .foregroundColor(.primaryFont)
            
            Text(subtitle)
                .carelyText(style: .bodySmall, weight: .light)
                .foregroundColor(.secondaryFont)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ProfileSetupHeaderView(
        title: "Any existing conditions?",
        subtitle: "Select all that apply to help us provide more personalized care for your needs."
    )
    .padding()
}
