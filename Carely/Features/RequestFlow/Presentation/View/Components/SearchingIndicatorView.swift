import SwiftUI

struct SearchingIndicatorView: View {
    let activeNursesCount: Int
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: Spacing.s16) {
            // Circle with icons
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    // Outer Ripple
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.1))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimating ? 2.0 : 1.0)
                        .opacity(isAnimating ? 0.0 : 1.0)
                    
                    // Inner Ripple
                    Circle()
                        .fill(Color.brandPrimary.opacity(0.2))
                        .frame(width: 100, height: 100)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .opacity(isAnimating ? 0.0 : 1.0)
                    
                    // Main Circle
                    Circle()
                        .fill(Color.brandPrimary)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "photo.on.rectangle.angled")
                                .foregroundColor(Color.surface)
                                .font(.system(size: 32))
                        )
                }
                
                Circle()
                    .fill(Color.surface)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .fill(Color.brandPrimary)
                            .frame(width: 28, height: 28)
                            .overlay(
                                Image(systemName: "cross.case.fill")
                                    .foregroundColor(Color.surface)
                                    .font(.system(size: 14))
                            )
                    )
                    .offset(x: 4, y: 4)
            }
            .padding(.top, Spacing.s24)
            .onAppear {
                withAnimation(
                    .easeOut(duration: 2.0)
                    .repeatForever(autoreverses: false)
                ) {
                    isAnimating = true
                }
            }
            
            // Text
            VStack(spacing: Spacing.s8) {
                Text("Searching for an available\nnurse...")
                    .carelyText(style: .heading3, weight: .bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.primaryFont)
                
                Text("We are currently connecting you with\nqualified caregivers in your immediate\narea. This usually takes less than 2 minutes.")
                    .carelyText(style: .bodySmall, weight: .regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color.secondaryFont)
                    .padding(.horizontal, Spacing.s20)
            }
            
            // Pill Badge
            HStack(spacing: Spacing.s8) {
                Circle()
                    .fill(Color.brandPrimary)
                    .frame(width: 6, height: 6)
                
                Text("\(activeNursesCount) nurses active nearby")
                    .carelyText(style: .caption, weight: .medium)
                    .foregroundColor(Color.brandPrimary) // Or secondaryFont depending on precise match, teal looks good here
            }
            .padding(.horizontal, Spacing.s16)
            .padding(.vertical, Spacing.s8)
            .background(Color.brandPrimary.opacity(0.1))
            .clipShape(Capsule())
            .padding(.top, Spacing.s8)
        }
    }
}

#Preview {
    SearchingIndicatorView(activeNursesCount: 3)
        .padding()
        .background(Color.backGround)
}
