//
//  OTPDigitInputField.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 16/07/2026.
//


import SwiftUI


struct OTPDigitInputField: View {
    @Binding var code: String
    let length: Int
    var isError: Bool = false

    @FocusState private var isFocused: Bool
    private let boxSize: CGFloat = 48

    var body: some View {
        ZStack {
            TextField("", text: $code)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .opacity(0)
                .frame(width: 1, height: 1)
                .onChange(of: code) { oldValue, newValue in // Updated for iOS 17+
                    let digitsOnly = newValue.filter(\.isNumber)
                    code = String(digitsOnly.prefix(length))
                }

            HStack(spacing: Spacing.s4) {
                ForEach(0..<length, id: \.self) { index in
                    digitBox(at: index)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { isFocused = true }
        }
    }

    @ViewBuilder
    private func digitBox(at index: Int) -> some View {
        let characters = Array(code)
        let hasDigit = index < characters.count
        let isActive = index == characters.count && isFocused

        RoundedRectangle.trueFit(Radius.r8)
            .stroke(borderColor(hasDigit: hasDigit, isActive: isActive), lineWidth: isActive ? 2 : 1)
            .background(
                RoundedRectangle.trueFit(Radius.r8)
                    .fill(Color.surface)
            )
            .frame(width: boxSize, height: boxSize)
            .overlay(
                Text(hasDigit ? String(characters[index]) : "-")
                    .carelyText(style: .heading3, weight: .semiBold)
                    .foregroundStyle(hasDigit ? Color.primaryFont : Color.hint)
            )
            .animation(TrueFitMotion.springSnappy, value: isActive)
    }

    private func borderColor(hasDigit: Bool, isActive: Bool) -> Color {
        if isError { return .error }
        if isActive { return .brandPrimary }
        if hasDigit { return .primaryVariant }
        return .divider
    }
}

#Preview {
    OTPDigitInputField(code: .constant("12"), length: 4)
        .padding()
}
