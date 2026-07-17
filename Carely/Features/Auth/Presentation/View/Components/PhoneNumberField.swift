//
//  PhoneNumberField.swift
//  Carely
//
//  Created by Mina on 17/07/2026.
//
import SwiftUI

struct PhoneNumberField: View {

    @Binding var phoneNumber: String
    var showError: Bool
    var onFocusChanged: (Bool) -> Void
    var onPhoneNumberChanged: (String) -> Void

    @FocusState private var isFocused: Bool

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Phone Number")
                .carelyText(style: .bodyLarge)

            HStack {

                HStack(spacing: 6) {
                    Text("🇪🇬")
                    Text("+20")
                    Divider().frame(height: 40)
                }

                TextField(
                    "000 000 0000",
                    text: $phoneNumber
                )
                .keyboardType(.phonePad)
                .focused($isFocused)
            }
            .padding()
            .background(Color(.infoContainer))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            if showError {
                Text("Enter a valid 10-digit number starting with 10, 11, 12, or 15")
                    .carelyText(style: .caption)
                    .foregroundStyle(.red)
            }
        }
        .onChange(of: isFocused) { _, newValue in
            onFocusChanged(newValue)
        }
        .onChange(of: phoneNumber) { _, newValue in
            onPhoneNumberChanged(newValue)
        }
    }
}

#Preview {
    PhoneNumberFieldPreviewContainer()
}

private struct PhoneNumberFieldPreviewContainer: View {
    @State private var phoneNumber = ""

    var body: some View {
        PhoneNumberField(
            phoneNumber: $phoneNumber,
            showError: false,
            onFocusChanged: { _ in },
            onPhoneNumberChanged: { _ in }
        )
    }
}
