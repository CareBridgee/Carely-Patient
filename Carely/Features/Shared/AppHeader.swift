import SwiftUI

struct AppHeader: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    
    var trailingIcon: String? = nil
    
    var onTrailingIconTapped: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color.brandPrimary)
                    .font(.system(size: 20, weight: .medium))
            }
            .frame(width: 36, alignment: .leading)
            
            Spacer()
            
            Text(title)
                .carelyText(style: .heading2, weight: .medium)
                .foregroundColor(Color.brandPrimary)
            
            Spacer()
            
            if let iconName = trailingIcon {
                Button(action: {
                    onTrailingIconTapped?()
                }) {
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: iconName)
                                .foregroundColor(.purple.opacity(0.5))
                                .font(.system(size: 14))
                        )
                }
                .frame(width: 36, alignment: .trailing)
            } else {
                Spacer().frame(width: 36)
            }
        }
        .padding(.top, 10)
    }
}
