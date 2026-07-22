import SwiftUI

struct NurseOfferCardView: View {
    let offer: NurseOffer
    var onDeclineTapped: () -> Void
    var onAcceptTapped: () -> Void
    
    var body: some View {
        VStack(spacing: Spacing.s16) {
            // Profile & Details
            HStack(alignment: .top, spacing: Spacing.s12) {
                // Image with online indicator
                ZStack(alignment: .bottomTrailing) {
                    // Profile Image placeholder
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundColor(Color.brandPrimary.opacity(0.3))
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                    
                    Circle()
                        .fill(Color.success)
                        .frame(width: 14, height: 14)
                        .overlay(
                            Circle().stroke(Color.surface, lineWidth: 2)
                        )
                        .offset(x: -2, y: -2)
                }
                
                // Name & Rating
                VStack(alignment: .leading, spacing: Spacing.s4) {
                    HStack {
                        Text("\(offer.name), \(offer.title)")
                            .carelyText(style: .bodyLarge, weight: .bold)
                            .foregroundColor(Color.primaryFont)
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.2f", offer.price))")
                            .carelyText(style: .bodyLarge, weight: .bold)
                            .foregroundColor(Color.brandPrimary)
                    }
                    
                    HStack(spacing: Spacing.s4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(Color.amber)
                            .font(.system(size: 12))
                        
                        Text(String(format: "%.1f", offer.rating))
                            .carelyText(style: .caption, weight: .bold)
                            .foregroundColor(Color.primaryFont)
                        
                        Text("•")
                            .foregroundColor(Color.secondaryFont)
                        
                        Text("\(offer.reviewsCount) reviews")
                            .carelyText(style: .caption, weight: .regular)
                            .foregroundColor(Color.secondaryFont)
                    }
                }
            }
            
            Divider()
                .background(Color.divider)
            
            // Location
            HStack(spacing: Spacing.s4) {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(Color.brandPrimary)
                    .font(.system(size: 14))
                
                Text("Riverside • \(String(format: "%.1f", offer.distance)) km")
                    .carelyText(style: .bodySmall, weight: .regular)
                    .foregroundColor(Color.secondaryFont)
                
                Spacer()
            }
            
            // Buttons
            HStack(spacing: Spacing.s12) {
                SecondaryButton(
                    title: "Decline",
                    radius: Radius.pill
                ) {
                    // decline action
                }
                
                PrimaryButton(
                    title: "Accept",
                    radius: Radius.pill
                ) {
                    // accept action
                }
            }
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .cornerRadius(Radius.r20)
        .carelyShadow(.sm)
    }
}

#Preview {
    NurseOfferCardView(offer: NurseOffer(
        id: "1",
        name: "Sarah Mitchell",
        title: "RN",
        price: 85.00,
        rating: 4.9,
        reviewsCount: 124,
        distance: 2.4,
        imageLink: ""
    ),
        onDeclineTapped: {
        print("Decline tapped in preview")
    },
        onAcceptTapped: {
        print("Accept tapped in preview")
    }
                       
    )
    
    .padding()
    .background(Color.backGround)
}
