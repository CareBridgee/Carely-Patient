import SwiftUI

struct NurseProfileCertificatesView: View {
    let profile: NurseDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text("Certificates")
                .carelyText(style: .bodyLarge, weight: .medium)
                .foregroundColor(Color.primaryFont)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Spacing.s16) {
                    ForEach(profile.certificates) { cert in
                        VStack(alignment: .leading, spacing: Spacing.s8) {
                            // Certificate image placeholder
                            Rectangle()
                                .fill(Color.surfaceVariant)
                                .frame(width: 180, height: 120)
                                .overlay(
                                    Image(systemName: "doc.text.fill")
                                        .font(.largeTitle)
                                        .foregroundColor(Color.brandPrimary.opacity(0.5))
                                )
                                .cornerRadius(Spacing.s8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Spacing.s8)
                                        .stroke(Color.divider, lineWidth: 1)
                                )
                            
                            Text(cert.name)
                                .carelyText(style: .bodySmall, weight: .semiBold)
                                .foregroundColor(Color.primaryFont)
                        }
                    }
                }
            }
        }
    }
}
