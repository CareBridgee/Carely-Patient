import SwiftUI

struct NurseProfileServicesView: View {
    let profile: NurseDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Provided Services")
                .carelyText(style: .bodyLarge, weight: .medium)
                .foregroundColor(Color.primaryFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            FlowLayout(spacing: Spacing.s8, lineSpacing: Spacing.s8) {
                ForEach(profile.providedServices, id: \.self) { service in
                    Text(service)
                        .carelyText(style: .bodySmall, weight: .medium)
                        .foregroundColor(Color.secondaryFont)
                        .padding(.horizontal, Spacing.s16)
                        .padding(.vertical, Spacing.s8)
                        .background(Color.brandPrimary.opacity(0.1))
                        .cornerRadius(100)
                }
            }
        }
    }
}
