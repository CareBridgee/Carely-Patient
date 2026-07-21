import SwiftUI

struct MeasurementInputCardView: View {
    let title: String
    let placeholder: String
    let unit: String
    @Binding var value: String
    var errorMessage: String? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            Text(title)
                .carelyText(style: .bodySmall, weight: .regular)
                .foregroundColor(.secondaryFont)
            
            HStack(spacing: Spacing.s8) {
                CarelyTextField(
                    placeholder: placeholder,
                    text: $value,
                    keyboardType: .decimalPad
                )
                
                Text(unit)
                    .carelyText(style: .bodySmall, weight: .regular)
                    .foregroundColor(.secondaryFont)
            }
            
            if let error = errorMessage, !error.isEmpty {
                Text(error)
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.red)
            }
        }
        .padding(Spacing.s16)
        .background(Color.white)
        .cornerRadius(Radius.r16)
        .carelyShadow(.sm)
    }
}
