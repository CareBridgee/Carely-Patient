import SwiftUI

struct OtherDiseasesSectionView: View {
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            HStack(spacing: Spacing.s8) {
                Image("other-diseases-icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: IconSize.s24, height: IconSize.s24)
                    .foregroundColor(.primaryFont)
                
                Text("Other Diseases")
                    .carelyText(style: .bodyLarge, weight: .medium)
                    .foregroundColor(.primaryFont)
            }
            
            CustomTextAreaView(
                placeholder: "Enter environmental, seasonal, or other specific diseases...",
                text: $text,
                minHeight: 100
            )
        }
    }
}
