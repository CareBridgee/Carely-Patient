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
    case appearancePicker(Binding<AppAppearance>)
}

struct SettingsRow: View {
    let iconName: String
    let title: String
    let trailing: SettingsRowTrailing
    var action: () -> Void = {}

    var body: some View {
        Group {
            if isInteractiveTrailing {
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

    private var isInteractiveTrailing: Bool {
        switch trailing {
        case .toggle, .appearancePicker:
            return true
        default:
            return false
        }
    }

    @ViewBuilder
    private var trailingView: some View {
        switch trailing {
        case .toggle(let binding):
            Toggle("", isOn: binding)
                .labelsHidden()
                .tint(.brandPrimary)

        case .appearancePicker(let binding):
            Menu {
                ForEach(AppAppearance.allCases) { option in
                    Button(action: {
                        binding.wrappedValue = option
                    }) {
                        HStack {
                            Text(option.rawValue)
                            if binding.wrappedValue == option {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack(spacing: Spacing.s4) {
                    Text(binding.wrappedValue.rawValue)
                        .carelyText(style: .bodySmall)
                        .foregroundColor(.secondaryFont)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.hint)
                }
            }

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

//#Preview {
//    VStack(spacing: Spacing.s16) {
//        SettingsRow(iconName: "globe", title: "Language", trailing: .value("English"))
//        SettingsRow(iconName: "moon.fill", title: "Dark Mode", trailing: .toggle(.constant(false)))
//        SettingsRow(iconName: "lock.shield.fill", title: "Privacy Policy", trailing: .chevron)
//    }
//    .padding()
//    .background(Color.backGround)
//}
