
//
//  CarelyTextFieldSize.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 18/07/2026.
//

import SwiftUI


 
public struct CarelyTextField: View {
 
    private let label: String?
    private let isRequired: Bool
    private let isOptional: Bool
 
    private let placeholder: String
    @Binding private var text: String
    private let size: CarelyTextFieldSize
    private let radius: CGFloat
 
    private let leadingIcon: String?
    private let trailingText: String?
    private let trailingIcon: String?
    private let onTrailingIconTap: (() -> Void)?
 
    private let keyboardType: UIKeyboardType
    private let textContentType: UITextContentType?
    private let autocapitalization: TextInputAutocapitalization
    private let autocorrectionDisabled: Bool
    private let isSecure: Bool
 
    private let isEnabled: Bool
    private let errorMessage: String?
    private let helperText: String?
    private let onEditingChanged: ((Bool) -> Void)?
    private let onCommit: (() -> Void)?
 
    @FocusState private var isFocused: Bool
    @State private var isSecureTextVisible = false
 
    /// - Parameters:
    ///   - label: Optional field label shown above the input.
    ///   - isRequired: Shows a red asterisk after the label.
    ///   - isOptional: Shows an "(optional)" hint after the label. Ignored if `isRequired` is true.
    ///   - placeholder: Placeholder text shown when `text` is empty.
    ///   - text: The bound input value.
    ///   - size: Drives height, padding, font, and icon size. Defaults to `.medium`.
    ///   - radius: Corner radius override. Defaults to `size.defaultRadius`.
    ///   - leadingIcon: Optional SF Symbol name shown at the field's leading edge.
    ///   - trailingText: Optional fixed suffix shown at the trailing edge (e.g. a unit like `"cm"`/`"kg"`).
    ///   - trailingIcon: Optional tappable SF Symbol shown at the trailing edge (e.g. a chevron or globe). Ignored if `isSecure` is true — the reveal toggle takes that slot.
    ///   - onTrailingIconTap: Tap handler for `trailingIcon`.
    ///   - keyboardType: Keyboard shown for this field. Defaults to `.default`.
    ///   - textContentType: iOS autofill content type (e.g. `.telephoneNumber`, `.emailAddress`, `.name`).
    ///   - autocapitalization: Defaults to `.sentences`.
    ///   - autocorrectionDisabled: Defaults to `false`.
    ///   - isSecure: Masks input and shows a reveal/hide toggle. Defaults to `false`.
    ///   - isEnabled: Disables interaction and switches to the disabled color pair. Defaults to `true`.
    ///   - errorMessage: When non-nil/non-empty, the field switches to its error style and this message renders below it. Owned by the caller (e.g. a ViewModel) — this view never invents its own validation rules.
    ///   - helperText: Supporting text shown below the field when there is no `errorMessage`.
    ///   - onEditingChanged: Called when focus changes, e.g. to trigger validation on blur.
    ///   - onCommit: Called when the user submits (return key).
    public init(
        label: String? = nil,
        isRequired: Bool = false,
        isOptional: Bool = false,
        placeholder: String = "",
        text: Binding<String>,
        size: CarelyTextFieldSize = .medium,
        radius: CGFloat? = nil,
        leadingIcon: String? = nil,
        trailingText: String? = nil,
        trailingIcon: String? = nil,
        onTrailingIconTap: (() -> Void)? = nil,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrectionDisabled: Bool = false,
        isSecure: Bool = false,
        isEnabled: Bool = true,
        errorMessage: String? = nil,
        helperText: String? = nil,
        onEditingChanged: ((Bool) -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self.label = label
        self.isRequired = isRequired
        self.isOptional = isOptional
        self.placeholder = placeholder
        self._text = text
        self.size = size
        self.radius = radius ?? size.defaultRadius
        self.leadingIcon = leadingIcon
        self.trailingText = trailingText
        self.trailingIcon = trailingIcon
        self.onTrailingIconTap = onTrailingIconTap
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.autocapitalization = autocapitalization
        self.autocorrectionDisabled = autocorrectionDisabled
        self.isSecure = isSecure
        self.isEnabled = isEnabled
        self.errorMessage = errorMessage
        self.helperText = helperText
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
 
    private var hasError: Bool {
        guard let errorMessage else { return false }
        return !errorMessage.isEmpty
    }
 
    private var borderColor: Color {
        if hasError { return .error }
        if !isEnabled { return .divider }
        if isFocused { return .brandPrimary }
        return .divider
    }
 
    private var borderWidth: CGFloat {
        (isFocused || hasError) ? 1.5 : 1
    }
 
    private var backgroundColor: Color {
        isEnabled ? .surfaceVariant : .disable
    }
 
    private var textColor: Color {
        isEnabled ? .primaryFont : .onDisable
    }
 
    private var adornmentColor: Color {
        if hasError { return .error }
        if isFocused { return .brandPrimary }
        return .hint
    }
 
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            if let label {
                labelRow(label)
            }
 
            fieldRow
                .padding(.horizontal, size.horizontalPadding)
                .frame(height: size.height)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle.carely(radius)
                        .stroke(borderColor, lineWidth: borderWidth)
                )
                .clipShape(RoundedRectangle.carely(radius))
                .animation(CarelyMotion.springDefault, value: isFocused)
                .animation(CarelyMotion.springDefault, value: hasError)
 
            if hasError {
                message(errorMessage ?? "", icon: "exclamationmark.circle.fill", color: .error)
            } else if let helperText, !helperText.isEmpty {
                message(helperText, icon: nil, color: .hint)
            }
        }
    }
 
 
    @ViewBuilder
    private func labelRow(_ label: String) -> some View {
        HStack(spacing: Spacing.s4) {
            Text(label)
                .carelyText(style: .bodySmall, weight: .medium)
                .foregroundColor(.secondaryFont)
 
            if isRequired {
                Text("*")
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.error)
            } else if isOptional {
                Text("(optional)")
                    .carelyText(style: .caption)
                    .foregroundColor(.hint)
            }
 
            Spacer(minLength: .zero)
        }
    }
 
    @ViewBuilder
    private var fieldRow: some View {
        HStack(spacing: size.contentSpacing) {
            if let leadingIcon {
                Image(systemName: leadingIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size.iconSize, height: size.iconSize)
                    .foregroundColor(adornmentColor)
            }
 
            inputField
                .carelyText(style: size.textStyle)
                .foregroundColor(textColor)
                .tint(.brandPrimary)
                .keyboardType(keyboardType)
                .textContentType(textContentType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled(autocorrectionDisabled)
                .disabled(!isEnabled)
                .focused($isFocused)
                .onChange(of: isFocused) {
                    onEditingChanged?(isFocused)
                }
                .onSubmit {
                    onCommit?()
                }
                .toolbar {
                    if isFocused && needsKeyboardDoneButton {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") { isFocused = false }
                                .carelyText(style: .bodyRegular, weight: .semiBold)
                        }
                    }
                }
 
            if isSecure {
                Button {
                    isSecureTextVisible.toggle()
                } label: {
                    Image(systemName: isSecureTextVisible ? "eye.slash.fill" : "eye.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.iconSize, height: size.iconSize)
                        .foregroundColor(.hint)
                }
                .disabled(!isEnabled)
            } else if let trailingText {
                Text(trailingText)
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.hint)
            } else if let trailingIcon {
                Button {
                    onTrailingIconTap?()
                } label: {
                    Image(systemName: trailingIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: size.iconSize, height: size.iconSize)
                        .foregroundColor(adornmentColor)
                }
                .disabled(!isEnabled || onTrailingIconTap == nil)
            }
        }
    }
 
    @ViewBuilder
    private var inputField: some View {
        if isSecure && !isSecureTextVisible {
            SecureField(placeholder, text: $text)
        } else {
            TextField(placeholder, text: $text)
        }
    }
 
    private var needsKeyboardDoneButton: Bool {
        switch keyboardType {
        case .numberPad, .phonePad, .decimalPad, .asciiCapableNumberPad:
            return true
        default:
            return false
        }
    }
 
    @ViewBuilder
    private func message(_ text: String, icon: String?, color: Color) -> some View {
        HStack(spacing: Spacing.s4) {
            if let icon {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: IconSize.s12, height: IconSize.s12)
            }
            Text(text)
                .carelyText(style: .caption)
        }
        .foregroundColor(color)
    }
}
 
// MARK: - Presets
 
/// Common field configurations so keyboard type, icon, and content type
public extension CarelyTextField {
 
    static func name(
        label: String,
        placeholder: String = "Full legal name",
        text: Binding<String>,
        isRequired: Bool = false,
        errorMessage: String? = nil,
        isEnabled: Bool = true
    ) -> CarelyTextField {
        CarelyTextField(
            label: label,
            isRequired: isRequired,
            placeholder: placeholder,
            text: text,
            leadingIcon: "person.fill",
            textContentType: .name,
            autocapitalization: .words,
            isEnabled: isEnabled,
            errorMessage: errorMessage
        )
    }
 
    static func phone(
        label: String = "Phone Number",
        placeholder: String = "(555) 000-0000",
        text: Binding<String>,
        isRequired: Bool = false,
        errorMessage: String? = nil,
        isEnabled: Bool = true
    ) -> CarelyTextField {
        CarelyTextField(
            label: label,
            isRequired: isRequired,
            placeholder: placeholder,
            text: text,
            leadingIcon: "phone.fill",
            keyboardType: .phonePad,
            textContentType: .telephoneNumber,
            autocapitalization: .never,
            isEnabled: isEnabled,
            errorMessage: errorMessage
        )
    }
 
    static func email(
        label: String = "Email",
        placeholder: String = "name@example.com",
        text: Binding<String>,
        isRequired: Bool = false,
        errorMessage: String? = nil,
        isEnabled: Bool = true
    ) -> CarelyTextField {
        CarelyTextField(
            label: label,
            isRequired: isRequired,
            placeholder: placeholder,
            text: text,
            leadingIcon: "envelope.fill",
            keyboardType: .emailAddress,
            textContentType: .emailAddress,
            autocapitalization: .never,
            autocorrectionDisabled: true,
            isEnabled: isEnabled,
            errorMessage: errorMessage
        )
    }
 
    static func measurement(
        label: String,
        placeholder: String,
        unit: String,
        text: Binding<String>,
        isRequired: Bool = false,
        errorMessage: String? = nil,
        isEnabled: Bool = true
    ) -> CarelyTextField {
        CarelyTextField(
            label: label,
            isRequired: isRequired,
            placeholder: placeholder,
            text: text,
            trailingText: unit,
            keyboardType: .decimalPad,
            isEnabled: isEnabled,
            errorMessage: errorMessage
        )
    }
 
    
    static func address(
        label: String,
        placeholder: String,
        text: Binding<String>,
        isOptional: Bool = false,
        errorMessage: String? = nil,
        isEnabled: Bool = true
    ) -> CarelyTextField {
        CarelyTextField(
            label: label,
            isOptional: isOptional,
            placeholder: placeholder,
            text: text,
            textContentType: .fullStreetAddress,
            autocapitalization: .words,
            isEnabled: isEnabled,
            errorMessage: errorMessage
        )
    }
}
 
// MARK: - Preview
 
#Preview {
    ScrollView {
        VStack(spacing: Spacing.s20) {
            CarelyTextField.name(
                label: "Contact Name",
                text: .constant(""),
                isRequired: true
            )
 
            CarelyTextField.phone(
                text: .constant("")
            )
 
            HStack(spacing: Spacing.s12) {
                CarelyTextField.measurement(
                    label: "Height",
                    placeholder: "170",
                    unit: "cm",
                    text: .constant("170")
                )
                CarelyTextField.measurement(
                    label: "Weight",
                    placeholder: "65",
                    unit: "kg",
                    text: .constant("65")
                )
            }
 
            CarelyTextField(
                label: "Country",
                text: .constant("United Kingdom"),
                trailingIcon: "chevron.down",
                onTrailingIconTap: {}
            )
 
            HStack(spacing: Spacing.s12) {
                CarelyTextField.address(label: "City", placeholder: "e.g. London", text: .constant(""))
                CarelyTextField.address(label: "Area", placeholder: "e.g. Camden", text: .constant(""))
            }
 
            HStack(spacing: Spacing.s12) {
                CarelyTextField.address(label: "Building", placeholder: "e.g. Block A", text: .constant(""), isOptional: true)
                CarelyTextField.address(label: "Apt No.", placeholder: "e.g. 4B", text: .constant(""), isOptional: true)
            }
 
            CarelyTextField(
                label: "Contact Name",
                isRequired: true,
                placeholder: "Full legal name",
                text: .constant(""),
                leadingIcon: "person.fill",
                errorMessage: "Contact name is required"
            )
 
            CarelyTextField(
                label: "Notes",
                placeholder: "This field is disabled",
                text: .constant("Locked value"),
                isEnabled: false
            )
        }
        .padding(Spacing.s16)
    }
    .background(Color.backGround)
}
