import SwiftUI

struct NurseProfileHeaderView: View {
    let profile: NurseDetails
    
    var body: some View {
        VStack(spacing: Spacing.s16) {
            // Profile Image
            AsyncImage(url: URL(string: profile.profileImageUrl)) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
                    .overlay(Image(systemName: "person.fill").foregroundColor(.white))
            }
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: Spacing.s24))
            .overlay(RoundedRectangle(cornerRadius: Spacing.s24).stroke(Color.surface, lineWidth: 4))
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
            .padding(.top, Spacing.s16)
            
            // Name & Title
            VStack(spacing: Spacing.s4) {
                Text("\(profile.fullName), \(profile.title)")
                    .carelyText(style: .bodyLarge, weight: .semiBold)
                    .foregroundColor(Color.primaryFont)
                
                Text(profile.specialty)
                    .carelyText(style: .bodyRegular)
                    .foregroundColor(Color.secondaryFont)
            }
            
            // Stats Pill
            HStack(spacing: 0) {
                VStack(spacing: Spacing.s2) {
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 14))
                        Text(String(format: "%.1f", profile.rating))
                            .carelyText(style: .bodyLarge, weight: .semiBold)
                    }
                    .foregroundColor(Color.brandPrimary)
                    
                    Text("\(profile.reviewsCount) Reviews")
                        .carelyText(style: .caption)
                        .foregroundColor(Color.secondaryFont)
                }
                .frame(maxWidth: .infinity)
                
                Divider()
                    .frame(height: 30)
                
                VStack(spacing: Spacing.s2) {
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "clock")
                            .font(.system(size: 14))
                        Text("\(profile.experienceYears)y")
                            .carelyText(style: .bodyLarge, weight: .semiBold)
                    }
                    .foregroundColor(Color.brandPrimary)
                    
                    Text("Experience")
                        .carelyText(style: .caption)
                        .foregroundColor(Color.secondaryFont)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.vertical, Spacing.s12)
            .background(Color.surface)
            .cornerRadius(100)
            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
        }
    }
}
