//
//  PhoneNumberField.swift
//  Carely
//
//  Created by Mina on 17/07/2026.
//
import SwiftUI

struct PhoneNumberField: View {

    @Binding var phoneNumber: String

    var body: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Phone Number")
                .carelyText(style: .bodyLarge)

            HStack {

                HStack(spacing: 6) {
                    Text("🇪🇬")
                    Text("+20")
                    Image(systemName: "chevron.down")
                }

                TextField(
                    "000 000 0000",
                    text: $phoneNumber
                )
                .keyboardType(.phonePad)
            }
            .padding()
            .background(Color(.infoContainer))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

//#Preview {
//    @Previewable @State var phoneNumber = ""
//    PhoneNumberField(phoneNumber: $phoneNumber)
//}
