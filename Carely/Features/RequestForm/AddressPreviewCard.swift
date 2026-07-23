//
//  AddressPreviewCard.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import SwiftUI

struct AddressPreviewCard: View {
    let address: PatientAddress?
    let onEditOrAddTapped: () -> Void
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.s8) {
            ZStack(alignment: .topTrailing) {
                Image("map-image")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 140)
                    .clipShape(RoundedRectangle.carely(Radius.r16))

                Label("Precise", systemImage: "location.fill")
                    .carelyText(style: .caption, weight: .semiBold)
                    .foregroundColor(.onSuccessContainer)
                    .padding(.horizontal, Spacing.s8)
                    .padding(.vertical, Spacing.s4)
                    .background(Color.successContainer)
                    .clipShape(Capsule())
                    .padding(Spacing.s8)
            }

            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.brandPrimary)

                Text(addressText)
                    .carelyText(style: .bodySmall, weight: .medium)
                    .foregroundColor(.primaryFont)

                Spacer(minLength: .zero)

                Button(action: onEditOrAddTapped) {
                    Text(address == nil ? "Add Address" : "Edit Address")
                        .carelyText(style: .bodySmall, weight: .semiBold)
                        .foregroundColor(.brandPrimary)
                }
            }
            .padding(Spacing.s12)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r12))

            if let errorMessage {
                Text(errorMessage)
                    .carelyText(style: .caption, weight: .medium)
                    .foregroundColor(.error)
            }
        }
    }

    private var addressText: String {
        guard let address else { return "No address added yet" }
        return "\(address.line1), \(address.line2), \(address.district)"
    }
}
