//
//  ChosenServiceRow.swift
//  Carely
//
//  Created by Mahmoud Raafat Mustafa on 22/07/2026.
//


import SwiftUI

struct ChosenServiceRow: View {
    let service: CareService
    let allServices: [CareService]
    let onSelect: (CareService) -> Void

    var body: some View {
        Menu {
            ForEach(allServices) { option in
                Button {
                    onSelect(option)
                } label: {
                    Label(option.title, systemImage: option.icon)
                }
            }
        } label: {
            HStack(spacing: Spacing.s12) {
                ZStack {
                    Circle()
                        .fill(Color.mintSurface)
                        .frame(width: Spacing.s40, height: Spacing.s40)
                    Image(systemName: service.icon)
                        .foregroundColor(.brandPrimary)
                }

                VStack(alignment: .leading, spacing: Spacing.s2) {
                    Text("Chosen Service")
                        .carelyText(style: .caption, weight: .regular)
                        .foregroundColor(.secondaryFont)
                    Text(service.title)
                        .carelyText(style: .bodyRegular, weight: .semiBold)
                        .foregroundColor(.brandPrimary)
                }

                Spacer(minLength: .zero)

                Image(systemName: "chevron.right")
                    .foregroundColor(.hint)
            }
            .padding(Spacing.s16)
            .background(Color.surface)
            .clipShape(RoundedRectangle.carely(Radius.r16))
        }
    }
}
