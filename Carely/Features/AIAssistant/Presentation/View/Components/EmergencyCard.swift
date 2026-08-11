//
//  EmergencyCard.swift
//  Carely
//
//  Created by Mohamed Ayman on 08/08/2026.
//

import SwiftUI

struct EmergencyCard: View {
    let advice: String
    let phoneNumber: String

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s12) {
            // Header: Emergency Icon + Title
            HStack(spacing: Spacing.s8) {
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Text("EMERGENCY MEDICAL NOTICE")
                    .carelyText(style: .caption, weight: .bold)
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, Spacing.s12)
            .padding(.vertical, Spacing.s8)
            .background(Color.red)
            .cornerRadius(10)

            // Emergency Advice Content
            if !advice.isEmpty {
                Text(advice)
                    .carelyText(style: .bodyRegular, weight: .medium)
                    .foregroundColor(Color.primaryFont)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Divider()
                .padding(.vertical, Spacing.s2)

            // Call Emergency Services Action Button
            Button(action: callEmergencyServices) {
                HStack(spacing: Spacing.s8) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 16, weight: .bold))
                    Text("Call Emergency Services (\(phoneNumber))")
                        .carelyText(style: .bodyRegular, weight: .bold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.red)
                .cornerRadius(14)
                .shadow(color: Color.red.opacity(0.3), radius: 6, x: 0, y: 3)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(Spacing.s16)
        .background(Color.surface)
        .cornerRadius(18)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color.red.opacity(0.4), lineWidth: 1.5)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 3)
    }

    private func callEmergencyServices() {
        let cleanNumber = phoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let targetNumber = cleanNumber.isEmpty ? phoneNumber : cleanNumber
        guard let url = URL(string: "tel://\(targetNumber)"),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
