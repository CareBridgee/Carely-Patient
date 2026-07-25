//
//  SettingsRow.swift
//  Carely
//
//  Created by Mina on 25/07/2026.
//

import SwiftUI

enum SettingsRowTrailing {
    case toggle(Binding<Bool>)
    case value(String)
    case chevron
}

struct SettingsRow: View {
    let iconName: String
    let title: String
    let trailing: SettingsRowTrailing
    var action: () -> Void = {}

    var body: some View {
        Group {
            if isTogglingRow {
                content
            } else {
                Button(action: action) {
                    content
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var content: some View {
        HStack(spacing: Spacing.s12) {
            Image(systemName: iconName)
                .font(.system(size: 16))
                .foregroundColor(.brandPrimary)
                .frame(width: 28)

            Text(title)
                .carelyText(style: .bodyRegular)
                .foregroundColor(.primaryFont)

            Spacer()

            trailingView
        }
        .padding(.vertical, Spacing.s4)
    }

    private var isTogglingRow: Bool {
        if case .toggle = trailing { return true }
        return false
    }

    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .toggle(let binding):
            Toggle("", isOn: binding)
                .labelsHidden()
                .tint(.brandPrimary)

        case .value(let text):
            HStack(spacing: Spacing.s4) {
                Text(text)
                    .carelyText(style: .bodySmall)
                    .foregroundColor(.secondaryFont)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.hint)
            }

        case .chevron:
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.hint)
        }
    }
}

#Preview {
    VStack(spacing: Spacing.s16) {
        SettingsRow(iconName: "globe", title: "Language", trailing: .value("English"))
        SettingsRow(iconName: "moon.fill", title: "Dark Mode", trailing: .toggle(.constant(false)))
        SettingsRow(iconName: "lock.shield.fill", title: "Privacy Policy", trailing: .chevron)
    }
    .padding()
    .background(Color.backGround)
}
