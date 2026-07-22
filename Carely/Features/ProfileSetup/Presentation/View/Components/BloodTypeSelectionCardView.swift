import SwiftUI

struct BloodTypeSelectionCardView: View {
    @Binding var selectedType: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            CarelyDropdownField(
                label: "Blood Type",
                placeholder: "Select your type",
                selectedItem: $selectedType,
                options: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
            )
            
            HStack(alignment: .top, spacing: Spacing.s4) {
                Image(systemName: "info.circle")
                    .font(.system(size: 12))
                    .foregroundColor(.brandPrimary)
                
                Text("Emergency responders need this in critical situations.")
                    .carelyText(style: .caption)
                    .foregroundColor(.hint)
            }
            .padding(.top, Spacing.s4)
        }
        .padding(Spacing.s16)
        .background(Color.white)
        .cornerRadius(Radius.r16)
        .carelyShadow(.sm)
    }
}
