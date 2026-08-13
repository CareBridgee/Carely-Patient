import SwiftUI

struct NurseProfileApproachView: View {
    let profile: NurseDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Personal Approach")
                .carelyText(style: .bodyLarge, weight: .medium)
                .foregroundColor(Color.primaryFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(profile.personalApproach)
                .carelyText(style: .bodyRegular)
                .foregroundColor(Color.secondaryFont)
                .italic()
                .padding(Spacing.s20)
                .background(Color.surface)
                .cornerRadius(Spacing.s16)
                .overlay(
                    RoundedRectangle(cornerRadius: Spacing.s16)
                        .stroke(Color.brandPrimary.opacity(0.05), lineWidth: 1)
                )
        }
    }
}
