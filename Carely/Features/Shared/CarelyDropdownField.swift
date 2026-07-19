import SwiftUI

public struct CarelyDropdownField: View {
    private let label: String?
    private let placeholder: String
    @Binding private var selectedItem: String
    private let options: [String]
    private let size: CarelyTextFieldSize
    private let radius: CGFloat
    private let isEnabled: Bool

    public init(
        label: String? = nil,
        placeholder: String = "",
        selectedItem: Binding<String>,
        options: [String],
        size: CarelyTextFieldSize = .medium,
        radius: CGFloat? = nil,
        isEnabled: Bool = true
    ) {
        self.label = label
        self.placeholder = placeholder
        self._selectedItem = selectedItem
        self.options = options
        self.size = size
        self.radius = radius ?? size.defaultRadius
        self.isEnabled = isEnabled
    }

    private var borderColor: Color {
        if !isEnabled { return .divider }
        return .divider
    }

    private var borderWidth: CGFloat {
        return 1
    }

    private var backgroundColor: Color {
        isEnabled ? .surfaceVariant : .disable
    }

    private var textColor: Color {
        isEnabled ? .primaryFont : .onDisable
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            if let label {
                HStack(spacing: Spacing.s4) {
                    Text(label)
                        .carelyText(style: .bodySmall, weight: .regular)
                        .foregroundColor(.secondaryFont)
                    Spacer(minLength: .zero)
                }
            }

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedItem = option
                    }) {
                        Text(option)
                    }
                }
            } label: {
                HStack(spacing: size.contentSpacing) {
                    Text(selectedItem.isEmpty ? placeholder : selectedItem)
                        .carelyText(style: size.textStyle)
                        .foregroundColor(selectedItem.isEmpty ? .hint : textColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12)) // Reduced size as requested previously
                        .foregroundColor(.hint)
                }
                .padding(.horizontal, size.horizontalPadding)
                .frame(height: size.height)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle.carely(radius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .clipShape(RoundedRectangle.carely(radius))
            }
            .disabled(!isEnabled)
        }
    }
}
