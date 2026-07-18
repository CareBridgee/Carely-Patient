import SwiftUI

public struct InfoBannerView: View {
    public let text: String
    public var iconName: String
    
    public init(text: String, iconName: String = "info.circle") {
        self.text = text
        self.iconName = iconName
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: Spacing.s12) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: IconSize.s20, height: IconSize.s20)
                .foregroundColor(Color.brandPrimary)
            
            Text(text)
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(Color.secondaryFont)
                .lineSpacing(Spacing.s4)
        }
        .padding(Spacing.s16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.primaryContainer)
        .clipShape(RoundedRectangle.trueFit(Radius.r12))
    }
}

#Preview {
    InfoBannerView(
        text: "Accurate addresses help our healthcare professionals reach you faster during emergencies."
    )
    .padding()
}
