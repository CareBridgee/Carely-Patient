import SwiftUI

public struct CustomTextAreaView: View {
    public let placeholder: String
    @Binding public var text: String
    public var minHeight: CGFloat
    
    public init(placeholder: String, text: Binding<String>, minHeight: CGFloat = 120) {
        self.placeholder = placeholder
        self._text = text
        self.minHeight = minHeight
    }
    
    public var body: some View {
        TextField(placeholder, text: $text, axis: .vertical)
            .carelyText(style: .bodyRegular)
            .foregroundColor(Color.primaryFont)
            .tint(Color.brandPrimary)
            .padding(Spacing.s16)
            .frame(minHeight: minHeight, alignment: .topLeading)
            .background(Color.surfaceVariant)
            .clipShape(RoundedRectangle.carely(Radius.r12))
    }
}

#Preview {
    CustomTextAreaView(
        placeholder: "e.g. Pneumonia treatment (2019, 5 days)...",
        text: .constant("")
    )
    .padding()
}
